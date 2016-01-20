- view: aircraft
  fields:
    - dimension: tail_number
      sql: ${TABLE}.tail_num 

    - dimension: plane_year
      type: int
      sql: aircraft.year_built+0    # defeat the JDBC automatic conversion to date because of the word 'year'
    
    - dimension: had_incident
      type: yesno
      sql: |
        (
          SELECT event_id 
          FROM accidents 
          WHERE aircraft.tail_num=accidents.registration_number 
          LIMIT 1)
    
    - measure: count
      type: count_distinct
      sql: ${TABLE}.tail_num
      detail: detail

    - dimension: certification
            
    - dimension: status_code
    - dimension: mode_s_code
    - dimension: fract_owner
    - dimension: owner_name
      sql: ${TABLE}.name      
    - dimension: city
    - dimension: state
      
  sets:
    detail: [tail_number, aircraft_models.detail* plane_year,]
    export: [plane_year, tail_number, count]


- view: aircraft_models
  fields:
    - dimension: manufacturer

    - measure: manufacturer_count
      type: count_distinct
      sets:
        - carriers.detail
      sql: ${TABLE}.manufacturer
      detail: aircraft_maker_detail 

      # show how to create a like to google.
    - dimension: name
      sql: ${TABLE}.model
      required_fields: [manufacturer]
      html: |
          <%= linked_value %> 
          <% if row["manufacturer"] %>
            <a href='http://www.google.com/search?q=<%= 
              row["aircraft_models.manufacturer"] + "+" + value 
            %>'>
            <img src=http://www.google.com/favicon.ico></a>
          <% end %>

    - dimension: seats
      type: number

    - measure: count
      type: count_distinct
      sql: ${TABLE}.model
      detail: detail
      
    - dimension: engines
      type: number

    - dimension: amateur
      type: yesno
      sql: ${TABLE}.amateur

    - dimension: weight
      type: number

  sets:
    detail: [name, manufacturer, seats, engines, count]
    aircraft_maker_detail: [manufacturer, flights.count, carriers.count,
      aircraft_models.count, origin.count, destinaiton.count]

     
- view: aircraft_types
  label: AIRCRAFT MODELS
  fields:
    - dimension: description