
#
# Accident reporting...
#
# 

- view: accidents
  fields:
    
    - dimension: event_id
      html: |
        <%= linked_value %> 
        <a href=http://www.ntsb.gov/aviationquery/brief.aspx?ev_id=<%= value %> >
           <img src=/images/arrow-black-right.png></a>

    - dimension: registration_number
    - dimension: investigation_type
      
    - dimension_group: event
      type: time
      timeframes: [time, date, dow, week, month, month_num, year]
      sql: event_date

    - dimension: severity
      sql_case: 
        Incident: |
            ${number_fatal_injuries} 
            + ${number_serious_injuries} + ${number_minor_injuries} = 0
        Minor: ${number_fatal_injuries} + ${number_serious_injuries} = 0
        Serious: ${number_fatal_injuries} = 0
        else: Fatal
      
    - dimension: number_injured
      units: people
      type: number
      sql: ${number_serious_injuries} + ${number_minor_injuries}

    - measure: total_injured
      type: sum
      units: people
      sql: ${number_injured}

    - dimension: uninjured
      sql: ${TABLE}.number_of_uninjured

    - measure: total_uninjured
      type: sum
      units: people
      sql: ${uninjured}

    - dimension: number_fatal_injuries
      type: number
      units: people
      sql: number_of_fatalities

    - measure: total_fatalities
      label: Total Fatalities
      type: sum
      units: people
      sql: ${number_fatal_injuries}
      
      
    - dimension: number_serious_injuries
      type: number
      units: people
      sql: ${TABLE}.number_of_serious_injuries

    - dimension: number_minor_injuries
      type: number
      units: people
      sql: ${TABLE}.number_of_minor_injuries


    # Is there more then one model of this aircraft?
    - dimension: oneoff_multi
      label: ACCIDENTS One off/Multi
      sql: |
        (SELECT IF(COUNT(*) > 1, "Multi", "One off") 
         FROM accidents a 
         WHERE a.model=accidents.model)
    
    - dimension: location
    - dimension: country

    - dimension: latitude
      type: number
      decimals: 4

    - dimension: longitude
      type: number
      decimals: 4

    - dimension: airport_code      
    - dimension: airport_name
    - dimension: injury_severity
    - dimension: aircraft_damage
    - dimension: aircraft_category
    - dimension: number_of_engines
    - dimension: engine_type
    - dimension: far_description      
    - dimension: schedule
    - dimension: purpose_of_flight
    - dimension: air_carrier
      sql: TRIM(${TABLE}.air_carrier)
    - dimension: weather_condition
    - dimension: broad_phase_of_flight
    - dimension: report_status
    - dimension: publication_date

    - dimension: amateur_built
      type: yesno
      sql: amateur_built = "Yes"

    - measure: count
      label: Number of Accidents
      type: count
      units: accidents
      sets: 
        - aircraft_models.detail
        - aircraft.detail
      detail: detail

    - measure: amateur_built_count
      type: count
      units: accidents
      filters: 
        amateur_built: "Yes"
      detail: detail

    - measure: country_count
      type: count
      sql: DISTINCT country
      detail: {base: [country, count, total_fatalities]}
  
    - measure: percent_amateur_built
      type: percentage
      sql: ${amateur_built_count}/${count}

    - measure: us_accidents_count
      type: count
      units: accidents
      filters: 
        country: United States
      detail: [detail*, -country]

    - measure: minor_accidents_count
      type: count
      units: accidents
      detail: detail
      filters: 
        severity: Minor

    - measure: incident_accidents_count
      type: count
      units: accidents
      detail: detail
      filters: 
        severity: Incident

    - measure: serious_accidents_count
      type: count
      units: accidents
      detail: detail
      filters: 
        severity: Serious

    - measure: fatal_accidents_count
      type: count
      units: accidents
      detail: detail
      filters: 
        severity: Fatal

  sets: 
    detail: [event_id, event_date, registration_number, aircraft_models.manufacturer, 
      investigation_type, 
      severity, number_injured, number_fatal_injuries, aircraft_damage,air_carrier]
