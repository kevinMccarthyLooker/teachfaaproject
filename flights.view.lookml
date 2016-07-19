
- view: flights
  sql_table_name: flights
  fields:
  
  
  - dimension: id2
    primary_key: true
    hidden: true
    type: number
    sql: ${TABLE}.id2

  - dimension: arrival_delay
    hidden: true
    type: number
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
    sql: ${TABLE}.dep_delay

  - dimension: destination
    type: string
    sql: ${TABLE}.destination
    
####################### TRAINING FIELDS ############################

  - dimension: 1_distance
    type: number
    sql: ${TABLE}.distance

  - measure: 1_total_distance
    type: sum
    sql: ${1_distance}
    
  - measure: 1_average_distance
    type: average
    sql: ${1_distance}
    
  - measure: 1_count
    type: count
    drill_fields: detail*
    
  - measure: 1_count_distance
    type: count_distinct
    sql: ${1_distance}
    
  - dimension: 1_distance_tiered
    type: tier
    sql: ${1_distance}
    style: integer #comment
    tiers: [0,100,200,400,600,800,1200,1600,3200]
    
  - dimension: 1_is_long_flight
    type: yesno
    sql: ${1_distance} > 1000
    
  - measure: 1_total_long_flight_distance
    type: sum
    sql: ${1_distance}
    filters:
      1_is_long_flight: Yes
      
  - measure: 1_count_long_flight
    type: count
    drill_fields: detail*
    filters:
      1_is_long_flight: Yes
    
  - measure: 1_percentage_long_flight_distance
    type: number
    value_format: '0.0%'
    sql: 1.0*${1_total_long_flight_distance}/NULLIF(${1_total_distance}, 0)
    
  - measure: 1_percentage_long_flights
    type: number
    value_format: '0.0%'
    sql: 1.0*${1_count_long_flight}/NULLIF(${1_count}, 0)
    
  - dimension: 1_aircraft_years_in_service
    type: number
    sql: extract(year from ${1_depart_date}) - ${aircraft.year_built}
    
  - dimension: 1_origin_and_destination
    type: string
    sql: ${aircraft_origin.full_name} || ' to ' || ${aircraft_destination.full_name}
    
    
  - dimension_group: 1_depart
    type: time
    timeframes: [raw, time, date, hour, hour_of_day, day_of_week, day_of_week_index, time_of_day, week, month_num, month, year, quarter, quarter_of_year]
    sql: ${TABLE}.dep_time
      
#################################################################################
        
  - dimension: diverted
    type: string
    sql: ${TABLE}.diverted

  - dimension: flight_num
    type: string
    sql: ${TABLE}.flight_num

  - dimension: flight_time
    type: number
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

#   - measure: percent_cancelled
#     type: number
#     decimals: 2
#     sql: 100.0 * ${cancelled_count}/${flight_count}
#     drill_fields: detail

#   - measure: percent_complete
#     type: number
#     decimals: 2
#     sql: 1.0 - ${percent_cancelled}
#     drill_fields: detail


# Hidden For Now 

#   - dimension: taxi_in
#     type: int
#     sql: ${TABLE}.taxi_in
# 
#   - dimension: taxi_out
#     type: int
#     sql: ${TABLE}.taxi_out


  sets: 
    detail:
      - 1_distance
      - origin
      - destination
      - arrival_status
    my_set: 
      - percent_complete
      - percent_cancelled
      
