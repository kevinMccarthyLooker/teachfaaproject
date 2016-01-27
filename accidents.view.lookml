- view: accidents
  sql_table_name: public.accidents
  fields:

  - dimension: id
    primary_key: true
    type: int
    sql: ${TABLE}.id

  - dimension: accident_number
    type: string
    sql: ${TABLE}.accident_number

  - dimension: air_carrier
    type: string
    sql: ${TABLE}.air_carrier

  - dimension: aircraft_category
    type: string
    sql: ${TABLE}.aircraft_category

  - dimension: aircraft_damage
    type: string
    sql: ${TABLE}.aircraft_damage

  - dimension: airport_code
    type: string
    sql: ${TABLE}.airport_code

  - dimension: airport_name
    type: string
    sql: ${TABLE}.airport_name

  - dimension: amateur_built
    type: string
    sql: ${TABLE}.amateur_built

  - dimension: broad_phase_of_flight
    type: string
    sql: ${TABLE}.broad_phase_of_flight

  - dimension: country
    type: string
    sql: ${TABLE}.country

  - dimension: engine_type
    type: string
    sql: ${TABLE}.engine_type

  - dimension_group: event
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.event_date

  - dimension: event_id
    type: string
    sql: ${TABLE}.event_id

  - dimension: far_description
    type: string
    sql: ${TABLE}.far_description

  - dimension: injury_severity
    type: string
    sql: ${TABLE}.injury_severity

  - dimension: investigation_type
    type: string
    sql: ${TABLE}.investigation_type

  - dimension: location
    type: string
    sql: ${TABLE}.location

  - dimension: latitude
    type: number
    sql: REGEXP_REPLACE(COALESCE(${TABLE}.latitude,'0'), '[^0-9.-]+', '') 
    
    
  - dimension: longitude
    type: number
    sql: REGEXP_REPLACE(COALESCE(${TABLE}.longitude,'0'), '[^0-9.-]+', '') 
    
  - dimension: map_location
    description: 'Latitude and Longitude location of the accident, with a link to the map!'
    type: location
    sql_latitude: CASE WHEN ${TABLE}.latitude != '' THEN ${TABLE}.latitude::float ELSE NULL END
    sql_longitude: CASE WHEN ${TABLE}.longitude != '' THEN ${TABLE}.longitude::float ELSE NULL END
  
  - dimension: make
    type: string
    sql: ${TABLE}.make

  - dimension: model
    type: string
    sql: ${TABLE}.model

  - dimension: number_of_engines
    type: number
    sql: ${TABLE}.number_of_engines

  - dimension: number_of_fatalities
    type: number
    sql: ${TABLE}.number_of_fatalities

  - dimension: number_of_minor_injuries
    type: number
    sql: ${TABLE}.number_of_minor_injuries

  - dimension: number_of_serious_injuries
    type: number
    sql: ${TABLE}.number_of_serious_injuries

  - dimension: number_of_uninjured
    type: number
    sql: ${TABLE}.number_of_uninjured

  - dimension_group: publication
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.publication_date

  - dimension: purpose_of_flight
    type: string
    sql: ${TABLE}.purpose_of_flight

  - dimension: registration_number
    type: string
    sql: ${TABLE}.registration_number

  - dimension: report_status
    type: string
    sql: ${TABLE}.report_status

  - dimension: schedule
    type: string
    sql: ${TABLE}.schedule

  - dimension: weather_condition
    type: string
    sql: ${TABLE}.weather_condition

  - measure: count
    type: count
    drill_fields: [id, airport_name]

