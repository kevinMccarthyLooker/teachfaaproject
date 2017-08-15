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

  #   - dimension: aero_cht
  #     type: string
  #     sql: ${TABLE}.aero_cht
  #
  #   - dimension: c_ldg_rts
  #     type: string
  #     sql: ${TABLE}.c_ldg_rts
  #
  #   - dimension: cbd_dir
  #     type: string
  #     sql: ${TABLE}.cbd_dir
  #
  #   - dimension: cbd_dist
  #     type: number
  #     value_format: decimal_0
  #     sql: ${TABLE}.cbd_dist

  #   - dimension: cert
  #     type: string
  #     sql: ${TABLE}.cert

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

#   dimension: cntl_twr {
#     type: string
#     sql: ${TABLE}.cntl_twr ;;
#   }

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

  #
  #   - dimension: cust_intl
  #     type: string
  #     sql: ${TABLE}.cust_intl
  #
  dimension: elevation {
    hidden: yes
    type: number
    value_format: "decimal_0"
    sql: ${TABLE}.elevation ;;
  }

  #   - dimension: faa_dist
  #     type: string
  #     sql: ${TABLE}.faa_dist
  #
  #   - dimension: faa_region
  #     type: string
  #     sql: ${TABLE}.faa_region
  #
  dimension: facility_type {
    type: string
    sql: ${TABLE}.fac_type ;;
  }

  #
  #   - dimension: fac_use
  #     type: string
  #     sql: ${TABLE}.fac_use
  #
  #   - dimension: fed_agree
  #     type: string
  #     sql: ${TABLE}.fed_agree

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

  #   - dimension: mil_rts
  #     type: string
  #     sql: ${TABLE}.mil_rts
  #
  #   - dimension: own_type
  #     type: string
  #     sql: ${TABLE}.own_type
  #
  #   - dimension: site_number
  #     type: string
  #     sql: ${TABLE}.site_number

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  measure: count {
    type: count
    drill_fields: [id, full_name]
  }

  #   - measure: with_control_tower_count
  #     type: count
  #     drill_fields: detail*
  #     filters:
  #       control_tower: Yes

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

##############################################################
# THIS IS A DERIVED TABLE TO SAMPLE HOW TEMPLATED FILTERS WORK
##############################################################

# - explore: airport_facts
view: airport_facts {
  derived_table: {
    sql: SELECT
        airports.code AS code,
        airports.state AS state,
        airports.county AS county,
        airports.city AS city,
        airports.full_name AS full_name,
        DATE(CASE WHEN airports.act_date = '' THEN to_date('1970-01-01', 'YYYY-MM-DD') else to_date(airports.act_date, 'MM/YYYY') END) AS active
      FROM public.airports AS airports
      WHERE {% condition state %} airports.state {% endcondition %}
        AND {% condition date %} to_date(airports.act_date, 'MM/YYYY') {% endcondition %}
      GROUP BY 1,2,3,4,5,6
       ;;
  }

  # FILTER FIELDS

  filter: state {
    type: string
    suggest_dimension: airports_state
  }

  filter: date {
    label: "Date Airport Became Active"
    type: date
  }

  # REGULAR FIELDS

  dimension: airports_code {
    type: string
    sql: ${TABLE}.code ;;
  }

  dimension: airports_state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: airports_county {
    type: string
    sql: ${TABLE}.county ;;
  }

  dimension: airports_city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: airports_full_name {
    type: string
    sql: ${TABLE}.full_name ;;
  }

  dimension_group: airports_active {
    type: time
    timeframes: [date, month, year]
    sql: ${TABLE}.active ;;
  }

  measure: count {
    type: count
  }
}
