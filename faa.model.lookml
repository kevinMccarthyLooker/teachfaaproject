- connection: red_flight

- include: "*.view.lookml"       # include all views in this project
- include: "*.dashboard.lookml"  # include all dashboards in this project


# 
# - explore: ontime
#   label: ontime_flights
# 
- explore: flights
  view: flights
  sql_always_where: dep_time > '1960-01-01'
  joins:
    - join: carriers
      sql_on: flights.carrier=carriers.code

    - join: origin
      from: airports
      sql_on: flights.origin=origin.code
      fields: [full_name, city, state, count]

    - join: destination
      from: airports
      sql_on: flights.destination=destination.code
      fields: [full_name, city, state, count]

    - join: aircraft
      sql_on: flights.tail_num = aircraft.tail_num
# 
#     - join: aircraft_flights_facts
#       foreign_key: flights.tail_num

    - join: aircraft_models
      using: aircraft_model_code
      required_joins: [aircraft]
       
#     - join: aircraft_types
#       sql_on: aircraft_models.aircraft_type_id = aircraft_types.aircraft_type_id
#       required_joins: [aircraft_models]
#  
#      
# - explore: airports
#   view: airports
#   
# - explore: aircraft
#   view: aircraft
#   joins:
#     - join: aircraft_models
#       using: aircraft_model_code
#        
#     - join: aircraft_types
#       sql_on: aircraft_models.aircraft_type_id = aircraft_types.aircraft_type_id
#       required_joins: [aircraft_models]
# # 
# #     - join: aircraft_flights_facts
# #       foreign_key: aircraft.tail_num
# 
# # - explore: accidents
# #   view: accidents
# #   joins:
# #     - join: aircraft
# #       sql_on: registration_number=aircraft.tail_num
