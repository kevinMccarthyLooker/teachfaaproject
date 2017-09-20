view: aircraft_flight_facts {
  derived_table: {
    sortkeys: ["tail_num"]
    distribution_style: even
    sql_trigger_value: select current_date ;;

    sql: SELECT tail_num AS tail_num
               ,SUM(distance) AS lifetime_distance
               ,COUNT(*) AS lifetime_flights
         FROM ontime
         GROUP BY tail_num
         ;;
  }


  dimension: tail_num {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.tail_num ;;
  }

  dimension: lifetime_distance {
    type: number
    sql: ${TABLE}.lifetime_distance ;;
  }

  dimension: lifetime_flights {
    type: number
    sql: ${TABLE}.lifetime_flights ;;
  }

  dimension: distance_per_flight {
    type: number
    sql: 1.0 * ${lifetime_distance}/NULLIF(${lifetime_flights},0) ;;
  }

  dimension: lifetime_distance_tier {
    type: tier
    tiers: [0, 1000000, 2000000, 3000000, 4000000, 5000000, 7500000]
    sql: ${lifetime_distance} ;;
  }

  dimension: lifetime_flights_tier {
    type: tier
    tiers: [0, 1000, 2000, 5000, 10000, 15000]
    sql: ${lifetime_flights} ;;
  }

  dimension: distance_per_flight_tier {
    type: tier
    tiers: [0, 250, 500, 750, 1000, 1500]
    sql: ${distance_per_flight} ;;
  }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }
#
#   set: detail {
#     fields: [tail_num, lifetime_distance, lifetime_flights]
#   }

}
