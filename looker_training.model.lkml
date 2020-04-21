connection: "red_flight"
# include all views in this project
include: "*.view"


# include all dashboards in this project
# include: "*.dashboard"

# explore: hr_looker_training_set {
#   label: "HR Looker Training Set"
# }

# view: hr_looker_training_set {
#   derived_table: {
#     distribution_style: all
#     sql: select
#       1 as employee_number,
#       'Joan of Arc' as name,
#       'Executive' as department,
#       35000 as salary,
#       2008 as hired_year,
#       'F' as gender

#       union all

#       select
#       2 as employee_number,
#       'Winston Churchill' as name,
#       'Executive' as department,
#       25000 as salary,
#       2009 as hired_year,
#       'M' as gender

#       union all

#       select
#       3 as employee_number,
#       'Karl Marx' as name,
#       'Finance' as department,
#       25000 as salary,
#       2009 as hired_year,
#       'M' as gender

#       union all

#       select
#       4 as employee_number,
#       'Mother Teresa' as name,
#       'HR' as department,
#       16000 as salary,
#       2010 as hired_year,
#       'F' as gender

#       union all

#       select
#       5 as employee_number,
#       'Barbra Streisand' as name,
#       'Sales' as department,
#       16000 as salary,
#       2010 as hired_year,
#       'F' as gender

#       union all

#       select
#       6 as employee_number,
#       'Elvis Presley' as name,
#       'Sales' as department,
#       8000 as salary,
#       2012 as hired_year,
#       'M' as gender

#       union all

#       select
#       7 as employee_number,
#       'Katy Perry' as name,
#       'Analytics' as department,
#       8000 as salary,
#       2012 as hired_year,
#       'F' as gender

#       union all

#       select
#       8 as employee_number,
#       'Justin Bieber' as name,
#       'Analytics' as department,
#       8000 as salary,
#       2012 as hired_year,
#       'M' as gender
#       ;;
#     sortkeys: ["employee_number"]
#     persist_for: "2000 hours"
#   }

#   ##  DIMENSIONS  ##


#   dimension: employee_number {
#     sql: ${TABLE}.employee_number ;;
#   }

#   dimension: name {
#     sql: ${TABLE}.name ;;
#   }

#   dimension: department {
#     sql: ${TABLE}.department ;;
#   }

#   dimension: salary {
#     type: number
#     sql: coalesce(${TABLE}.salary,0) ;;
#     value_format: "$#,##0"
#   }

#   dimension: gender {
#     sql: ${TABLE}.gender ;;
#   }

#   dimension: hired_year {
#     type: number
#     sql: ${TABLE}.hired_year ;;
#   }

#   dimension: years_employed {
#     type: number
#     sql: coalesce(cast(extract(year from current_date) - ${hired_year} as decimal),0) ;;
#   }

#   ##  MEASURES  ##

#   measure: employee_count {
#     type: count
#     drill_fields: [detail*]
#   }

#   measure: department_count {
#     type: count_distinct
#     sql: ${department} ;;
#   }

#   measure: salary_count {
#     type: count_distinct
#     sql: ${salary} ;;
#   }

#   measure: average_salary {
#     type: average
#     value_format: "$#,##0"
#     sql: ${salary} ;;
#   }

#   measure: total_salary {
#     type: sum
#     value_format: "$#,##0"
#     sql: ${salary} ;;
#   }

#   measure: average_years_employed {
#     type: average
#     sql: ${years_employed} ;;
#   }

#   measure: total_years_employed {
#     type: sum
#     sql: ${years_employed} ;;
#   }

#   set: detail {
#     fields: [employee_number, name, department, salary, hired_year]
#   }
# }

# explore: ecomm_looker_training_set {}

# view: ecomm_looker_training_set {
#   view_label: "eComm"

#   derived_table: {
#     sql: select
#       'Julius Blank' as customer_name,
#       'Organic' as marketing_channel,
#       2014 as year_joined,
#       150 as lifetime_value,
#       'F' as gender

#       union all

#       select
#       'Victor Grinich' as customer_name,
#       'Display' as marketing_channel,
#       2015 as year_joined,
#       50 as lifetime_value,
#       'M' as gender

#       union all

#       select
#       'Jean Hoerni' as customer_name,
#       'Paid Search' as marketing_channel,
#       2013 as year_joined,
#       120 as lifetime_value,
#       'M' as gender

#       union all

#       select
#       'Eugene Kleiner' as customer_name,
#       'Organic' as marketing_channel,
#       2012 as year_joined,
#       200 as lifetime_value,
#       'F' as gender

#       union all

#       select
#       'Jay Last' as customer_name,
#       'Blog' as marketing_channel,
#       2013 as year_joined,
#       150 as lifetime_value,
#       'F' as gender

#       union all

#       select
#       'Gordon Moore' as customer_name,
#       'Display' as marketing_channel,
#       2015 as year_joined,
#       50 as lifetime_value,
#       'M' as gender

#       union all

#       select
#       'Robert Noyce' as customer_name,
#       'Organic' as marketing_channel,
#       2011 as year_joined,
#       300 as lifetime_value,
#       'F' as gender

#       union all

#       select
#       'Sheldon Roberts' as customer_name,
#       'Paid Search' as marketing_channel,
#       2012 as year_joined,
#       200 as lifetime_value,
#       'M' as gender
#       ;;
#   }

#   ##  DIMENSIONS  ##


#   dimension: customer_name {
#     sql: ${TABLE}.customer_name ;;
#   }

#   dimension: marketing_channel {
#     sql: ${TABLE}.marketing_channel ;;
#   }

#   dimension: lifetime_value {
#     type: number
#     sql: coalesce(${TABLE}.lifetime_value,0) ;;
#     value_format: "$#,##0"
#   }

#   dimension: gender {
#     sql: ${TABLE}.gender ;;
#   }

#   dimension: year_joined {
#     type: number
#     value_format: "0"
#     sql: ${TABLE}.year_joined ;;
#   }

#   dimension: years_a_customer {
#     type: number
#     sql: coalesce(cast(extract(year from current_date) -  ${TABLE}.year_joined as decimal),0) ;;
#   }

#   ##  MEASURES  ##

#   measure: customer_count {
#     type: count
#   }

#   measure: marketing_channel_count {
#     type: count_distinct
#     sql: ${marketing_channel} ;;
#   }

#   measure: lifetime_value_count {
#     type: count_distinct
#     sql: ${lifetime_value} ;;
#   }

#   measure: average_lifetime_value {
#     type: average
#     value_format: "$#,##0"
#     sql: ${lifetime_value} ;;
#   }

#   measure: total_lifetime_value {
#     type: sum
#     value_format: "$#,##0"
#     sql: ${lifetime_value} ;;
#   }

#   measure: average_years_a_customer {
#     type: average
#     sql: ${years_a_customer} ;;
#   }

#   measure: total_years_a_customer {
#     type: sum
#     sql: ${years_a_customer} ;;
#   }

#   # set: detail {
#   #   fields: [employee_number, name, department, salary, hired_year]
#   # }
# }


explore: fruit_basket {}
view: fruit_basket {
  sql_table_name: public.fruit_basket ;;

  dimension: fruit_type {
    type: string
    sql: ${TABLE}.fruit_type ;;
  }

  dimension: color {
    type: string
    sql: ${TABLE}.color ;;
  }

  dimension: is_round {
    type: string
    sql: ${TABLE}.is_round ;;
  }

  dimension: price_per_pound {
    type: number
    sql: ${TABLE}.price_per_pound ;;
  }

  dimension: weight {
    type: number
    sql: ${TABLE}.weight ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;;
  }

  measure: count {
    type: count
  }

  measure: average_weight {
    type: average
    value_format_name: decimal_2
    sql: ${weight} ;;
  }

  measure: average_price {
    type: average
    value_format_name: usd
    sql: ${price} ;;
  }

  measure: total_weight {
    type: sum
    value_format_name: decimal_2
    sql: ${weight} ;;
  }

  measure: total_price {
    type: sum
    value_format_name: usd
    sql: ${price} ;;
  }

  measure: average_price_per_pound{
    type: average
    value_format_name: usd
    sql: ${price_per_pound} ;;
  }

  measure: count_types {
    type: count_distinct
    sql: ${fruit_type} ;;
  }

  measure: count_color {
    type: count_distinct
    sql: ${color} ;;
  }

}
