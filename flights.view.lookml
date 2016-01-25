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
    type: int
    sql: ${TABLE}.arr_delay

  - dimension_group: arrival
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.arr_time

  - dimension: cancelled
    type: string
    sql: ${TABLE}.cancelled

  - dimension: carrier
    type: string
    sql: ${TABLE}.carrier

  - dimension: departure_delay
    hidden: true
    type: int
    sql: ${TABLE}.dep_delay

  - dimension_group: departure
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.dep_time

  - dimension: destination
    type: string
    sql: ${TABLE}.destination

  - dimension: distance
    type: int
    sql: ${TABLE}.distance

  - dimension: diverted
    type: string
    sql: ${TABLE}.diverted

  - dimension: flight_num
    type: string
    sql: ${TABLE}.flight_num

  - dimension: flight_time
    type: int
    sql: ${TABLE}.flight_time

  - dimension: origin
    type: string
    sql: ${TABLE}.origin
  
  - dimension: tail_num
    type: string
    sql: ${TABLE}.tail_num

# Hidden For Now 

# 
#   - dimension: taxi_in
#     type: int
#     sql: ${TABLE}.taxi_in
# 
#   - dimension: taxi_out
#     type: int
#     sql: ${TABLE}.taxi_out

  - measure: count
    type: count
    drill_fields: []

