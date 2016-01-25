- view: carriers
  sql_table_name: public.carriers
  fields:

  - dimension: code
    primary_key: true
    type: string
    sql: ${TABLE}.code

  - dimension: name
    type: string
    sql: ${TABLE}.name

  - dimension: nickname
    type: string
    sql: ${TABLE}.nickname

  - measure: count
    type: count
    drill_fields: [name, nickname]

