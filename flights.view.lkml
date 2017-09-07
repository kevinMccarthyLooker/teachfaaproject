view: flights {
  sql_table_name: flights ;;


 dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id2 ;;
  }

  dimension: arrival_delay {
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.arr_delay ;;
  }

  dimension_group: arrival {
    type: time
    timeframes: [time, date, week, month, year, raw]
    sql: ${TABLE}.arr_time ;;
  }

  dimension: cancelled {
    type: string
    sql: ${TABLE}.cancelled ;;
  }

  dimension: carrier {
    type: string
    sql: ${TABLE}.carrier ;;
  }

  dimension: departure_delay {
    hidden: yes
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.dep_delay ;;
  }

  dimension: destination {
    type: string
    sql: ${TABLE}.destination ;;
  }

  ####################### TRAINING FIELDS ############################

  dimension: 1_distance {
    type: number
    sql: ${TABLE}.distance ;;
  }

  measure: 1_total_distance {
    type: sum
    sql: ${1_distance} ;;
  }

  measure: 1_average_distance {
    type: average
    sql: ${1_distance} ;;
  }

  measure: 1_count {
    type: count
    drill_fields: [detail*]
  }

  measure: 1_count_distance {
    type: count_distinct
    sql: ${1_distance} ;;
  }

  dimension: 1_distance_tiered {
    type: tier
    sql: ${1_distance} ;;
    style: integer
    tiers: [0, 100, 200, 400, 600, 800, 1200, 1600, 3200]
  }

  dimension: 1_is_long_flight {
    type: yesno
    sql: ${1_distance} > 1000 ;;
  }

  measure: 1_total_long_flight_distance {
    type: sum
    sql: ${1_distance} ;;

    filters: {
      field: 1_is_long_flight
      value: "Yes"
    }
  }

  measure: 1_count_long_flight {
    type: count

    filters: {
      field: 1_is_long_flight
      value: "Yes"
    }
  }

  measure: 1_percentage_long_flight_distance {
    type: number
    value_format: "0.0%"
    sql: 1.0*${1_total_long_flight_distance}/NULLIF(${1_total_distance}, 0) ;;
  }

  measure: 1_percentage_long_flights {
    type: number
    value_format: "0.0%"
    sql: 1.0*${1_count_long_flight}/NULLIF(${1_count}, 0) ;;
  }

  dimension: 1_aircraft_years_in_service {
    type: number
    sql: extract(year from ${1_depart_date}) - ${aircraft.year_built} ;;
  }

  dimension: 1_origin_and_destination {
    type: string
    sql: ${aircraft_origin.full_name}  || ' to ' || ${aircraft_destination.full_name} ;;
  }

  dimension_group: 1_depart {
    type: time
    timeframes: [time, date, week, month, year, raw]
    sql: ${TABLE}.dep_time ;;
  }

  #################################################################################

  dimension: diverted {
    type: string
    sql: ${TABLE}.diverted ;;
  }

  dimension: flight_num {
    type: string
    sql: ${TABLE}.flight_num ;;
  }

  dimension: flight_time {
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.flight_time ;;
  }

  dimension: flight_time_tiered {
    type: tier
    sql: ${flight_time} ;;
    style: integer
    tiers: [10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240,250,260,270,280,290,300,310,320,330,350,360]
  }

  dimension: 1_distance_tiered_2 {
    type: tier
    sql: ${1_distance} ;;
    style: integer
    tiers: [0, 200, 400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000]
  }

  measure: log_count_flights {
    type: number
    sql: log(count(distinct ${id})) ;;
    value_format_name: decimal_2
  }

  dimension: origin {
    type: string
    sql: ${TABLE}.origin ;;
  }

  dimension: tail_num {
    type: string
    sql: ${TABLE}.tail_num ;;
  }

  dimension: arrival_status {
    case: {
      when: {
        sql: ${TABLE}.cancelled='Y' ;;
        label: "Cancelled"
      }

      when: {
        sql: ${TABLE}.diverted='Y' ;;
        label: "Diverted"
      }

      when: {
        sql: ${TABLE}.arr_delay > 60 ;;
        label: "Very Late"
      }

      when: {
        sql: ${TABLE}.arr_delay BETWEEN -10 and 10 ;;
        label: "OnTime"
      }

      when: {
        sql: ${TABLE}.arr_delay > 10 ;;
        label: "Late"
      }

      else: "Early"
    }
  }

  measure: cancelled_count {
    type: count
    drill_fields: [detail*]

    filters: {
      field: cancelled
      value: "Y"
    }
  }

  measure: not_cancelled_count {
    type: count
    drill_fields: [detail*]

    filters: {
      field: cancelled
      value: "N"
    }
  }

  set: detail {
    fields: [1_distance, origin, destination, arrival_status]
  }

}
