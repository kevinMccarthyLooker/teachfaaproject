view: airports {
  sql_table_name: public.airports ;;

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    value_format: "decimal_0"
    sql: ${TABLE}.id ;;
  }

  dimension_group: active_date {
    type: time
    timeframes: [date, week, month, year]
    convert_tz: no
    sql: CASE WHEN ${TABLE}.act_date = '' THEN to_date('1970-01-01', 'YYYY-MM-DD') else to_date(${TABLE}.act_date, 'MM/YYYY') END ;;
  }

  dimension: act_date {
    description: "Date this airport became active, Default is 01/1970"
    type: string
    sql: CASE WHEN ${TABLE}.act_date = '' THEN '01/1970' ELSE ${TABLE}.act_date END ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: cntl_twr {
    type: string
    sql: ${TABLE}.cntl_twr ;;
  }

  dimension: control_tower {
    type: yesno
    sql: ${TABLE}.cntl_twr = 'Y' ;;
  }

  dimension: code {
    type: string
    sql: ${TABLE}.code ;;
  }

  dimension: county {
    type: string
    sql: ${TABLE}.county ;;
  }

  dimension: elevation {
    hidden: yes
    type: number
    value_format: "decimal_0"
    sql: ${TABLE}.elevation ;;
  }

  dimension: facility_type {
    type: string
    sql: ${TABLE}.fac_type ;;
  }

  dimension: full_name {
    type: string
    sql: ${TABLE}.full_name ;;
  }

  dimension: joint_use {
    type: yesno
    sql: ${TABLE}.joint_use = 'Y' ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: map_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: is_major {
    type: yesno
    sql: ${TABLE}.major = 'Y' ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  measure: count {
    type: count
    drill_fields: [id, full_name]
  }

  measure: min_elevation {
    type: min
    sql: ${elevation} ;;
  }

  measure: max_elevation {
    type: max
    sql: ${elevation} ;;
  }

  measure: average_elevation {
    type: average
    sql: ${elevation} ;;
  }

  measure: with_control_tower_count {
    type: count
    filters: {
        field: control_tower
        value: "Yes"
    }
  }
}
