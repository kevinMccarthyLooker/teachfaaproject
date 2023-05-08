view: carriers {
  # sql_table_name: carriers ;;
  #5/8/2023
  derived_table: {
    sql: select string_field_0 as code, string_field_1 as name,string_field_2 as nickname from carriers where string_field_0 <>'code' ;;
  }

  dimension: code {
    primary_key: yes
    type: string
    sql: ${TABLE}.code ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: nickname {
    type: string
    sql: ${TABLE}.nickname ;;
  }

  measure: count {
    type: count
    drill_fields: [name, nickname]
  }
}
