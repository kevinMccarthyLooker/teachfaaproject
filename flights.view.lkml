view: flights {
  sql_table_name: flights ;;

 dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id2 ;;
  }

###################### TRAINING FIELDS ###########################

  dimension: distance {
    type: number
    sql: ${TABLE}.distance ;;
  }

  measure: total_distance {
    type: sum
    sql: ${distance} ;;
  }

  measure: average_distance {
    type: average
    sql: ${distance} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_distance {
    type: count_distinct
    sql: ${distance} ;;
  }

  dimension: distance_tiered {
    type: tier
    sql: ${distance} ;;
    style: integer
    tiers: [0, 100, 200, 400, 600, 800, 1200, 1600, 3200]
  }

  dimension: is_long_flight {
    type: yesno
    sql: ${distance} > 1000 ;;
  }

  measure: total_long_flight_distance {
    type: sum
    sql: ${distance} ;;

    filters: {
      field: is_long_flight
      value: "Yes"
    }
  }

  measure: count_long_flight {
    type: count

    filters: {
      field: is_long_flight
      value: "Yes"
    }
  }

  measure: percentage_long_flight_distance {
    type: number
    value_format: "0.0%"
    sql: 1.0*${total_long_flight_distance}/NULLIF(${total_distance}, 0) ;;
  }

  measure: percentage_long_flights {
    type: number
    value_format: "0.0%"
    sql: 1.0*${count_long_flight}/NULLIF(${count}, 0) ;;
  }

  dimension: aircraft_years_in_service {
    type: number
    sql: extract(year from ${depart_date}) - ${aircraft.year_built} ;;
  }

  dimension: origin_and_destination {
    type: string
    sql: ${aircraft_origin.full_name}  || ' to ' || ${aircraft_destination.full_name} ;;
  }

  dimension_group: depart {
    type: time
    timeframes: [time, date, week, month, year, raw]
    sql: ${TABLE}.dep_time ;;
  }

########################################################################################

  dimension: arrival_delay {
    view_label: "Flights Details"
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.arr_delay ;;
  }

  dimension_group: arrival {
    view_label: "Flights Details"
    type: time
    timeframes: [time, date, week, month, year, raw]
    sql: ${TABLE}.arr_time ;;
  }

  dimension: cancelled {
    view_label: "Flights Details"
    type: string
    sql: ${TABLE}.cancelled ;;
  }

  dimension: carrier {
    view_label: "Flights Details"
    type: string
    sql: ${TABLE}.carrier ;;
  }

  dimension: departure_delay {
    view_label: "Flights Details"
    hidden: yes
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.dep_delay ;;
  }

  dimension: destination {
    view_label: "Flights Details"
    type: string
    sql: ${TABLE}.destination ;;
  }

  dimension: diverted {
    view_label: "Flights Details"
    type: string
    sql: ${TABLE}.diverted ;;
  }

  dimension: flight_num {
    view_label: "Flights Details"
    type: string
    sql: ${TABLE}.flight_num ;;
  }

  dimension: flight_time {
    view_label: "Flights Details"
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.flight_time ;;
  }

  dimension: flight_time_tiered {
    view_label: "Flights Details"
    type: tier
    sql: ${flight_time} ;;
    style: integer
    tiers: [10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240,250,260,270,280,290,300,310,320,330,350,360]
  }

  measure: log_count_flights {
    view_label: "Flights Details"
    type: number
    sql: log(count(distinct ${id})) ;;
    value_format_name: decimal_2
  }

  dimension: origin {
    view_label: "Flights Details"
    type: string
    sql: ${TABLE}.origin ;;
  }

  dimension: tail_num {
    view_label: "Flights Details"
    type: string
    sql: ${TABLE}.tail_num ;;
  }

  dimension: arrival_status {
    view_label: "Flights Details"
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
    view_label: "Flights Details"
    type: count
    drill_fields: [detail*]

    filters: {
      field: cancelled
      value: "Y"
    }
  }

  measure: not_cancelled_count {
        view_label: "Flights Details"
    type: count
    drill_fields: [detail*]

    filters: {
      field: cancelled
      value: "N"
    }
  }

  set: detail {
    fields: [distance, origin, destination, arrival_status]
  }


}
