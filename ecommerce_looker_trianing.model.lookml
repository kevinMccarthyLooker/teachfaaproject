- connection: red_flight

- include: "*.view.lookml"       # include all views in this project
- include: "*.dashboard.lookml"  # include all dashboards in this project

- explore: ecomm_looker_training_set
- view: ecomm_looker_training_set
  derived_table:
    sql: |
      select
      'Julius Blank' as customer_name,
      'Organic' as marketing_channel,
      2013 as year_joined,
      150 as lifetime_value,
      'F' as gender
      
      union all
      
      select
      'Victor Grinich' as customer_name,
      'Display' as marketing_channel,
      2015 as year_joined,
      50 as lifetime_value,
      'M' as gender
      
      union all
      
      select
      'Jean Hoerni' as customer_name,
      'Paid Search' as marketing_channel,
      2013 as year_joined,
      120 as lifetime_value,
      'M' as gender
      
      union all
      
      select
      'Eugene Kleiner' as customer_name,
      'Organic' as marketing_channel,
      2012 as year_joined,
      200 as lifetime_value,
      'F' as gender
      
      union all
      
      select
      'Jay Last' as customer_name,
      'Blog' as marketing_channel,
      2013 as year_joined,
      150 as lifetime_value,
      'F' as gender
      
      union all
      
      select
      'Gordon Moore' as customer_name,
      'Display' as marketing_channel,
      2015 as year_joined,
      50 as lifetime_value,
      'M' as gender
      
      union all
      
      select
      'Robert Noyce' as customer_name,
      'Organic' as marketing_channel,
      2011 as year_joined,
      300 as lifetime_value,
      'F' as gender
      
      union all
      
      select
      'Sheldon Roberts' as customer_name,
      'Paid Search' as marketing_channel,
      2012 as year_joined,
      200 as lifetime_value,
      'M' as gender


  fields:


##  DIMENSIONS  ##


  - dimension: customer_name
    sql: ${TABLE}.customer_name


  - dimension: marketing_channel
    sql: ${TABLE}.marketing_channel


  - dimension: lifetime_value
    type: number
    sql: coalesce(${TABLE}.lifetime_value,0)
    value_format: '$#,##0'
    
  - dimension: gender
    sql: ${TABLE}.gender


  - dimension: year_joined
    type: number
    sql: ${TABLE}.year_joined
    
  - dimension: years_a_customer
    type: number
    sql: coalesce(cast(extract(year from current_date) - ${year_joined} as decimal),0)
    
##  MEASURES  ##
    
  - measure: customer_count
    type: count
    
  - measure: marketing_channel_count
    type: count_distinct
    sql: ${marketing_channel}
    
  - measure: lifetime_value_count
    type: count_distinct
    sql: ${lifetime_value}
    
  - measure: average_lifetime_value
    type: average
    value_format: '$#,##0'
    sql: ${lifetime_value}
    
  - measure: total_lifetime_value
    type: sum
    value_format: '$#,##0'
    sql: ${lifetime_value}
    
  - measure: average_years_a_customer
    type: average
    sql: ${years_a_customer}
    
  - measure: total_years_a_customer
    type: sum
    sql: ${years_a_customer}


  sets:
    detail:
      - employee_number
      - name
      - department
      - salary
      - hired_year


