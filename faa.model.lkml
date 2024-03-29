# connection: "red_flight"
connection: "kevmccarthy_bq" # ADJUSTED 8/17/2023 BECAUSE RED_FLIGHT NO LONGER AVAILABLE
# include all views in this project
include: "*.view"
# include all dashboards in this project
# include: "*.dashboard"
# persist_for: "3 hours"

explore: flights {
  description: "Start here for information about flights!"
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

  join: aircraft_origin {
    from: airports
    type: left_outer
    sql_on: ${flights.origin} = ${aircraft_origin.code} ;;
    relationship: many_to_one
    fields: [full_name, city, state, code,map_location]
  }

  join: aircraft_destination {
    from: airports
    type: left_outer
    sql_on: ${flights.destination} = ${aircraft_destination.code} ;;
    relationship: many_to_one
    fields: [full_name, city, state, code]
  }

  join: aircraft_flight_facts {
    # view_label: "Aircraft"
    type: left_outer
    sql_on: ${aircraft.tail_num} = ${aircraft_flight_facts.tail_num} ;;
    relationship: one_to_one
  }

  join: aircraft_models {
    sql_on: ${aircraft.aircraft_model_code} = ${aircraft_models.aircraft_model_code} ;;
    relationship: many_to_one
  }
}

explore: airports {}
