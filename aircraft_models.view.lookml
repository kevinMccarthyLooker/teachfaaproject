- view: aircraft_models
  sql_table_name: public.aircraft_models
  fields:

  - dimension: aircraft_category_id
    type: int
    sql: ${TABLE}.aircraft_category_id

  - dimension: aircraft_engine_type_id
    type: int
    sql: ${TABLE}.aircraft_engine_type_id

  - dimension: aircraft_model_code
    type: string
    sql: ${TABLE}.aircraft_model_code

  - dimension: aircraft_type_id
    type: int
    sql: ${TABLE}.aircraft_type_id

  - dimension: amateur
    type: int
    sql: ${TABLE}.amateur

  - dimension: engines
    type: int
    sql: ${TABLE}.engines

  - dimension: manufacturer
    type: string
    sql: ${TABLE}.manufacturer

  - dimension: model
    type: string
    sql: ${TABLE}.model

  - dimension: seats
    type: int
    sql: ${TABLE}.seats

  - dimension: speed
    type: int
    sql: ${TABLE}.speed

  - dimension: weight
    type: int
    sql: ${TABLE}.weight

  - measure: count
    type: count
    drill_fields: []

