# - connection: red_flight
# - include: "*.view.lookml"       # include all the views
# 
# 
# ## Analyze Accidents
# 
# - explore: accidents
#   joins:
#   - join: carriers
#     type: left_outer
#     relationship: many_to_one
#     sql_on: ${air_carrier}=${carriers.code}
# #######################################################################################################################################
# 
# ## Analyze Aircraft
# 
# - explore: aircraft
#   label: 'Aircraft' 
#   joins:
#     - join: aircraft_models
#       view_label: 'Aircraft' 
#       type: left_outer
#       sql_on: ${aircraft.aircraft_model_code} = ${aircraft_models.aircraft_model_code}
#       relationship: many_to_one
#     
#     - join: aircraft_flight_facts
#       view_label: 'Aircraft' 
#       type: left_outer
#       sql_on: ${aircraft.tail_num} = ${aircraft_flight_facts.tail_num}
#       relationship: one_to_one
#       
# #######################################################################################################################################
# 
# 
# ## Analyze Flights, but include aircraft
# 
# - explore: flights
#   extends: aircraft
#   joins: 
#     - join: carriers
#       type: left_outer
#       sql_on: ${flights.carrier} = ${carriers.code}
#       relationship: many_to_one
#       
#     - join: flight_origin
#       from: airports
#       type: left_outer
#       sql_on: ${flights.origin} = ${aircraft_origin.code}
#       relationship: one_to_one
#       fields: [full_name, city, state, code]
#     
#     - join: flight_destination
#       from: airports
#       type: left_outer
#       sql_on: ${flights.destination} = ${aircraft_destination.code}
#       relationship: one_to_one
#       fields: [full_name, city, state, code]
# 
#     - join: aircraft
#       type: left_outer
#       sql_on: ${flights.tail_num} = ${aircraft.tail_num}
#       relationship: many_to_one
#   
# ###   Using Extensions, I am logically adding in the following from the "aircraft" explore
# ###   (I need to include 'aircraft' above, because here I am replacing a base table)
#     
# #     - join: aircraft_models
# #       view_label: 'Aircraft' 
# #       type: left_outer
# #       sql_on: ${aircraft.aircraft_model_code} = ${aircraft_models.aircraft_model_code}
# #       relationship: many_to_one
# #     
# #     - join: aircraft_flight_facts
# #       view_label: 'Aircraft' 
# #       type: left_outer
# #       sql_on: ${aircraft.tail_num} = ${aircraft_flight_facts.tail_num}
# #       relationship: one_to_one
# 
# 
# 
# 
# #######################################################################################################################################
# 
# # 
# # - explore: myflights
# #   extends: [airports, flights]
# #   joins:
# #   - join: airports
# #     relationship: many_to_one
# #     from: airports
# #     sql_on: ${flights.destination} = ${airports.code}
# #   
