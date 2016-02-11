- view: flights
  sql_table_name: public.flights
  fields:
  
  - dimension: id2
    primary_key: true
    hidden: true
    type: number
    sql: ${TABLE}.id2

  - dimension: arrival_delay
    hidden: true
    type: number 
    value_format_name: decimal_0
    sql: ${TABLE}.arr_delay

  - dimension_group: arrival
    type: time
    timeframes: [time, date, week, month, year]
    sql: ${TABLE}.arr_time

  - dimension: cancelled
    type: string
    sql: ${TABLE}.cancelled

  - dimension: carrier
    type: string
    sql: ${TABLE}.carrier

  - dimension: departure_delay
    hidden: true
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.dep_delay

  - dimension_group: departure
    type: time
    timeframes: [time, date, week, month, year]
    sql: ${TABLE}.dep_time

  - dimension: destination
    type: string
    sql: ${TABLE}.destination

  - dimension: distance
    type: number
    sql: ${TABLE}.distance
  
  - dimension: distance_tiered
    type: tier
    sql: ${distance}
    style: interval
    tiers: [0,100,200,400,600,800,1200,1600,3200]
  
  - dimension: is_long_flight
    type: yesno
    sql: ${distance} > 1000


  - dimension: aircraft_years_in_service
    type: number
    sql: extract(year from ${departure_date}) - ${aircraft.year_built}
        
  - dimension: diverted
    type: string
    sql: ${TABLE}.diverted

  - dimension: flight_num
    type: string
    sql: ${TABLE}.flight_num

  - dimension: flight_time
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.flight_time

  - dimension: origin
    type: string
    sql: ${TABLE}.origin
  
  - dimension: tail_num
    type: string
    sql: ${TABLE}.tail_num
  
  - dimension: arrival_status
    sql_case:
      Cancelled: ${TABLE}.cancelled='Y'
      Diverted: ${TABLE}.diverted='Y'
      Very Late: ${TABLE}.arr_delay > 60
      OnTime: ${TABLE}.arr_delay BETWEEN -10 and 10
      Late: ${TABLE}.arr_delay > 10
      else: Early
    
  - measure: flight_count
    type: count
    drill_fields: detail*

  - measure: total_distance
    type: sum
    sql: ${distance}
    drill_fields: detail
    
  - measure: average_distance
    type: average
    sql: ${distance}
    drill_fields: detail
    
  - measure: total_long_flight_distance
    type: sum
    sql: ${distance}
    drill_fields: detail
    filters:
      is_long_flight: Yes
      
  - measure: count_number_of_long_flights
    type: count
    drill_fields: detail*
    filters:
      is_long_flight: Yes
    
  - measure: percentage_long_flights
    type: number
    value_format: '0.0\%'
    sql: 100.00*${count_number_of_long_flights}/NULLIF(${flight_count}, 0)
    drill_fields: detail
    
  
  - measure: cancelled_count
    type: count
    drill_fields: detail
    filters: 
      cancelled: Yes  

  - measure: not_cancelled_count
    type: count
    drill_fields: detail
    filters: 
      cancelled: No 

  - measure: percent_cancelled
    type: number
    decimals: 2
    sql: 100.0 * ${cancelled_count}/${flight_count}
    drill_fields: detail

  - measure: percent_complete
    type: number
    decimals: 2
    sql: 1.0 - ${percent_cancelled}
    drill_fields: detail


# Hidden For Now 

#   - dimension: taxi_in
#     type: number
# value_format_name: decimal_0
#     sql: ${TABLE}.taxi_in
# 
#   - dimension: taxi_out
#     type: number
# value_format_name: decimal_0
#     sql: ${TABLE}.taxi_out


  sets: 
    detail: 
      - flight_name
      - distance
      - origin
      - destination
      - arrival_status
    
      
