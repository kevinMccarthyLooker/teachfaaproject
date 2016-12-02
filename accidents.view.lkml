view: accidents {
  sql_table_name: public.accidents ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: accident_number {
    type: string
    sql: ${TABLE}.accident_number ;;
  }

  dimension: air_carrier {
    type: string
    sql: ${TABLE}.air_carrier ;;
  }

  dimension: aircraft_category {
    type: string
    sql: ${TABLE}.aircraft_category ;;
  }

  dimension: aircraft_damage {
    type: string
    sql: ${TABLE}.aircraft_damage ;;
  }

  dimension: airport_code {
    type: string
    sql: ${TABLE}.airport_code ;;
  }

  dimension: airport_name {
    type: string
    sql: ${TABLE}.airport_name ;;
  }

  dimension: amateur_built {
    type: yesno
    sql: ${TABLE}.amateur_built='Yes' ;;
  }

  dimension: broad_phase_of_flight {
    type: string
    sql: ${TABLE}.broad_phase_of_flight ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: engine_type {
    type: string
    sql: ${TABLE}.engine_type ;;
  }

  dimension_group: event {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.event_date ;;
  }

  dimension: event_id {
    type: string
    sql: ${TABLE}.event_id ;;
  }

  dimension: far_description {
    type: string
    sql: ${TABLE}.far_description ;;
  }

  dimension: injury_severity {
    type: string
    sql: ${TABLE}.injury_severity ;;
  }

  dimension: investigation_type {
    type: string
    sql: ${TABLE}.investigation_type ;;
  }

  dimension: location {
    description: "Location Text (i.e. Atlanta, GA)"
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: latitude {
    hidden: yes
    type: number
    sql: REGEXP_REPLACE(COALESCE(${TABLE}.latitude,'0'), '[^0-9.-]+', '') ;;
  }

  dimension: longitude {
    hidden: yes
    type: number
    sql: REGEXP_REPLACE(COALESCE(${TABLE}.longitude,'0'), '[^0-9.-]+', '') ;;
  }

  dimension: map_location {
    description: "Latitude and Longitude location of the accident, with a link to the map!"
    type: location
    sql_latitude: CASE WHEN ${TABLE}.latitude != '' THEN ${TABLE}.latitude::float ELSE NULL END ;;
    sql_longitude: CASE WHEN ${TABLE}.longitude != '' THEN ${TABLE}.longitude::float ELSE NULL END ;;
  }

  dimension: make {
    description: "Aircraft Make"
    label: "Aircraft Make"
    type: string
    sql: ${TABLE}.make ;;
  }

  dimension: model {
    description: "Aircraft Model"
    label: "Aircraft Model"
    type: string
    sql: ${TABLE}.model ;;
  }

  dimension: number_of_engines {
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_engines ;;
  }

  dimension: number_of_fatalities {
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_fatalities ;;
  }

  dimension: number_of_minor_injuries {
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_minor_injuries ;;
  }

  dimension: number_of_serious_injuries {
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_serious_injuries ;;
  }

  dimension: number_of_uninjured {
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_uninjured ;;
  }

  dimension_group: publication {
    type: time
    timeframes: [date, week, month, year, hour_of_day, day_of_week]
    sql: ${TABLE}.publication_date ;;
  }

  dimension: purpose_of_flight {
    type: string
    sql: ${TABLE}.purpose_of_flight ;;
  }

  dimension: registration_number {
    type: string
    sql: ${TABLE}.registration_number ;;
  }

  dimension: report_status {
    type: string
    sql: ${TABLE}.report_status ;;
  }

  dimension: schedule {
    type: string
    sql: ${TABLE}.schedule ;;
  }

  dimension: weather_condition_input {
    type: string
    sql: ${TABLE}.weather_condition ;;
  }

  dimension: weather_condition {
    type: string
    description: "Aircraft weather condition as visual reference or instrument only reference"

    case: {
      when: {
        sql: ${weather_condition_input} = 'VMC' ;;
        label: "visual"
      }

      when: {
        sql: ${weather_condition_input} = 'IMC' ;;
        label: "instruments_only"
      }

      else: "other"
    }
  }

  measure: accident_count {
    type: count
    drill_fields: [id, airport_name]
  }

  measure: total_number_of_fatalities {
    type: sum
    value_format_name: decimal_0
    sql: ${number_of_fatalities} ;;
  }

  measure: total_number_of_minor_injuries {
    type: sum
    value_format_name: decimal_0
    sql: ${number_of_minor_injuries} ;;
  }

  measure: total_number_of_serious_injuries {
    type: sum
    value_format_name: decimal_0
    sql: ${number_of_serious_injuries} ;;
  }

  measure: total_number_of_uninjured {
    type: sum
    value_format_name: decimal_0
    sql: ${number_of_uninjured} ;;
  }

  dimension: number_injured {
    type: number
    sql: (${number_of_uninjured}+${number_of_fatalities}+${number_of_minor_injuries}+${number_of_serious_injuries}) ;;
  }

  measure: total_number_injured {
    type: sum
    sql: ${number_injured} ;;
  }

  measure: percent_injured {
    value_format_name: percent_2
    sql: ${total_number_of_uninjured} ;;
  }
}
