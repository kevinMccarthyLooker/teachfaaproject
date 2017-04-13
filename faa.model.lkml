connection: "red_flight"
# include all views in this project
include: "*.view"
# include all dashboards in this project
include: "*.dashboard"








explore: airports {}

explore: flights {
  join: carriers {
    type: left_outer
    sql_on: ${flights.carrier} = ${carriers.code} ;;
    relationship: many_to_one
  }

  join: aircraft {
    type: left_outer
    sql_on: ${flights.tail_num} = ${aircraft.tail_num} ;;
    relationship: many_to_one
  }

  join: aircraft_flight_facts {
    #       view_label: 'Aircraft'
    type: left_outer
    sql_on: ${aircraft.tail_num} = ${aircraft_flight_facts.tail_num} ;;
    relationship: one_to_one
  }

  join: aircraft_origin {
    from: airports
    type: left_outer
    sql_on: ${flights.origin} = ${aircraft_origin.code} ;;
    relationship: many_to_one
    fields: [full_name, city, state, code]
  }

  join: aircraft_destination {
    from: airports
    type: left_outer
    sql_on: ${flights.destination} = ${aircraft_destination.code} ;;
    relationship: many_to_one
    fields: [full_name, city, state, code]
  }
}

# examples of filtering explores
#
#   explore: flights_data {
#   from: flights
#   sql_always_where: dep_time > '1960-01-01'
#   sql_always_having: count < 10000
#   always_filter
#   conditionaly_filter:
#   access_filter_fields
#   join: carriers {
#     type: left_outer
#     sql_on: ${flights.carrier} = ${carriers.code} ;;
#     relationship: many_to_one
#   }
# }
