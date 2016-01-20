
- view: airports
  fields:
    - dimension: code                   # sql defaults to ${TABLE}.code  
      primary_key: true
      
    - dimension: city                   # sql defaults to ${TABLE}.city
    - dimension: state
    - dimension: full_name

    - dimension: facility_type          # rename the sql field.
      sql: ${TABLE}.fac_type
      
    - dimension: control_tower          # convert a 'Y' in the database
      type: yesno                       #  to a yesno field.
      sql: ${TABLE}.cntl_twr = 'Y'

    - dimension: elevation              # string is default type, numbers need to
      type: number                      #  be declared.

    - measure: count                    # count the number of different
      type: count                       #  airport codes we encounter.
      detail: detail                    # the set of fields to show when we drill
                                        #  into AIRPORTS Count

    - measure: with_control_tower_count
      type: count     
      detail: detail                    # set of fields to drill into
      filters:
        control_tower: Yes              # only count airports with control towers.

    - dimension: average_elevation
      type: average
      sql: ${TABLE}.elevation           # AVG(airports.elevation)

    - measure: min_elevation
      type: min
      sql: ${TABLE}.elevation           # MIN(airports.elevation)
      
    - measure: max_elevation
      type: max
      sql: ${TABLE}.elevation

    - dimension: elevation_range
      sql_case:
        High: ${elevation} > 8000
        Medium: ${elevation} BETWEEN 3000 and 7999
        else: Low
        
    - dimension: elevation_tier
      type: tier
      sql: ${elevation}
      tiers: [0, 100, 250, 1000, 2000, 3000, 4000, 5000, 6000]
      
  # Fields to show when drilling.
  sets:
    detail: [code, city, state, full_name, control_tower, facility_type]
  
  