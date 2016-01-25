- view: flights
  sql_table_name: public.flights
  fields:

  - dimension: arr_delay
    type: int
    sql: ${TABLE}.arr_delay

  - dimension_group: arr
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.arr_time

  - dimension: cancelled
    type: string
    sql: ${TABLE}.cancelled

  - dimension: carrier
    type: string
    sql: ${TABLE}.carrier

  - dimension: dep_delay
    type: int
    sql: ${TABLE}.dep_delay

  - dimension_group: depart
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.dep_time

  - dimension: destination
    type: string
    sql: ${TABLE}.destination

############################## Training fields #######################

  - dimension: 1__distance
    type: number
    sql: ${TABLE}.distance

  - measure: 1__total_distance
    type: sum
    sql: ${1__distance}
    
  - measure: 1__average_distance
    type: average
    sql: ${1__distance}
    
  - measure: 1__count
    type: count
    drill_fields: detail*
    
  - dimension: 1__distance_tiered
    type: tier
    sql: ${1__distance}
    style: interval
    tiers: [0,100,200,400,600,800,1200,1600,3200]
    
    
  - dimension: 1__is_long_flight
    type: yesno
    sql: ${1__distance} > 1000
    
  - measure: 1__total_long_flight_distance
    type: sum
    sql: ${1__distance}
    filters:
      1__is_long_flight: Yes
      
  - measure: 1__count_long_flight_distance
    type: count
    drill_fields: detail*
    filters:
      1__is_long_flight: Yes
    
  - measure: 1__percentage_long_flight_distance
    type: number
    value_format: '0.0\%'
    sql: 100.00*${1__total_long_flight_distance}/NULLIF(${1__total_distance}, 0)
    
  - measure: 1__percentage_long_flights
    type: number
    value_format: '0.0\%'
    sql: 100.00*${1__count_long_flight_distance}/NULLIF(${1__count}, 0)
    
  - dimension: 1__aircraft_years_in_service
    type: number
    sql: extract(year from ${depart_date}) - ${aircraft.year_built}
        

      
#####################################################################

  - dimension: diverted
    type: string
    sql: ${TABLE}.diverted

  - dimension: flight_num
    type: string
    sql: ${TABLE}.flight_num

  - dimension: flight_time
    type: int
    sql: ${TABLE}.flight_time

  - dimension: id2
    type: number
    sql: ${TABLE}.id2

  - dimension: origin
    type: string
    sql: ${TABLE}.origin

  - dimension: tail_num
    type: string
    sql: ${TABLE}.tail_num

  - dimension: taxi_in
    type: int
    sql: ${TABLE}.taxi_in

  - dimension: taxi_out
    type: int
    sql: ${TABLE}.taxi_out

