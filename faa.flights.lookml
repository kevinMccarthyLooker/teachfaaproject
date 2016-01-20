
- view: flights
  derived_table:
    # remove some bogus flights.
    sql: |
        SELECT * 
        FROM ontime 
        WHERE dep_time > '1960-01-01'
    sortkeys: [dep_time]
    persist_for: 2000 hours
    
  fields:
    - dimension: tail_num    
  
    - dimension_group: depart
      type: time
      timeframes: [time, date, hour, hod, dow, dow_num, tod, week, month_num, month, year]
      sql: ${TABLE}.dep_time

    - dimension: arr_time
      type: datetime
  
    - dimension: origin
    - dimension: destination

    - measure: destinations_list
      type: list
      list_field: destination
      
    - measure: destination_cities
      type: list
      list_field: destination.city
      required_joins: [destination]

    - measure: routes_count
      type: count_distinct
      sql: CONCAT_WS("|", origin, destination)
      detail: route_detail

    - dimension: carrier

    - dimension: flight_number
      postgres_sql: ${TABLE}.carrier || ${TABLE}.flight_num
      mysql_sql: CONCAT(${TABLE}.carrier, ${TABLE}.flight_num)

    - measure: flight_number_count
      type: count_distinct
      sql: ${flight_number}
      detail: flight_num_detail 

    - dimension: time
      type: number
      sql: ${TABLE}.flight_time

    - measure: average_flight_time
      type: average
      sql: ${TABLE}.flight_time

    - measure: total_flight_time
      type: sum
      sql: ${TABLE}.flight_time

    - dimension: distance
      sql: ${TABLE}.distance
  
    - dimension: distance_tiered
      type: tier
      sql: ${distance}
      tiers: [100,200,400,600,800,1200,1600,3200]
      
    - measure: total_distance
      type: sum
      sql: ${TABLE}.distance

     
    - dimension: plane_age_at_flight
      type: number
      required_joins: [aircraft]
      sql: IF(aircraft.year_built>1950, (YEAR(dep_time)*1.0 - aircraft.year_built), NULL)
      
    - dimension: page_age_at_flight_tier
      type: tier
      sql: ${plane_age_at_flight}
      tiers: [2,4,8,16,32]
      
    - measure: weighted_plane_age
      type: average
      sql: ${plane_age_at_flight}

    - dimension: arrival_status
      sql_case:
        Cancelled: ${TABLE}.cancelled='Y'
        Diverted: ${TABLE}.diverted='Y'
        Very Late: ${TABLE}.arr_delay > 60
        OnTime: ${TABLE}.arr_delay BETWEEN -10 and 10
        Late: ${TABLE}.arr_delay > 10
        else: Early
        
    - measure: count
      type: count
      detail: detail

    - measure: ontime_count
      type: count
      detail: detail
      filters: 
        arrival_status: OnTime

    - measure: percent_ontime
      type: percentage
      sql: ${ontime_count}/${count}

    - measure: late_count
      type: count
      detail: detail
      filters: 
        arrival_status: Late

    - measure: percent_late
      type: number
      sql: 100.0 * ${late_count}/NULLIF(${count},0)
      decimals: 2

    - measure: verylate_count
      type: count
      detail: detail
      filters: 
        arrival_status: Very Late  

    - measure: percent_verylate
      type: percentage
      sql: ${verylate_count}/${count}
  
    - dimension: cancelled
      type: yesno
      sql: ${arrival_status} = 'Cancelled'
  
    - measure: cancelled_count
      type: count
      detail: detail
      filters: 
        cancelled: Yes  

    - measure: not_cancelled_count
      type: count
      detail: detail
      filters: 
        cancelled: No 

    - measure: percent_cancelled
      type: number
      decimals: 2
      sql: 100.0 * ${cancelled_count}/${count}

    - measure: percent_complete
      type: number
      decimals: 2
      sql: 1.0 - ${percent_cancelled}

    - measure: diverted_count
      type: count
      detail: detail
      filters: 
        arrival_status: Diverted
        
    - measure: percent_diverted
      type: number
      decimals: 2
      sql: 100.0 * ${diverted_count}/${count}

    - measure: average_seats
      type: average
      sql: aircraft_models.seats
      required_joins: [aircraft_models]

    - measure: total_seats
      type: sum
      sql: aircraft_models.seats
      required_joins: [aircraft_models]

    - dimension: depart_delay
      type: number
      sql: ${TABLE}.dep_delay

    - dimension: arr_delay
      type: number

    - dimension: taxi_out_time
      type: number
      sql: ${TABLE}.taxi_out

    - dimension: taxi_in_time
      type: number
      sql: ${TABLE}.taxi_in
     
  sets:
    origin.detail: [origin count, aircraft,count, carriers.count, .aircraft_models.count, 
        aircraft_models.manufacturer_count]
    destination.detail: [count, aircraft.count, carriers.count, .aircraft_models.count, 
        aircraft_models.manufacturer_count]
    detail: [tail_num, flight_number, depart_time, carriers.name,  origin, origin.city, destination,  
      destination.city,]
    route_detail: [origin, origin.city, destination, destination.city, carriers.count,
      count]
       
      
- view: carriers
 
  fields:
    - dimension: code      
    - dimension: name
      sql: ${TABLE}.nickname

    - dimension: names
      type: list
      list_field: name

    - measure: count
      type: count_distinct
      sql: ${TABLE}.code
      detail: detail
  sets:
    detail: [code, name, flights.count, origin.count, destination.count]
