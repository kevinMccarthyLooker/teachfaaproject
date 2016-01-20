- dashboard: flights_facts
  title: Fun Flight Facts
  layout: tile
  tile_size: 100
  elements:

    - name: flight_and_carriers_by_year
      type: table
      base_view: flights
      dimensions: [carriers.name]
      pivots: [flights.depart_year]
      measures: [flights.count]
      limit: 500
      width: 8
      height: 5
    
    - name: number_of_flights_from_CA
      type: single_value
      base_view: flights
      measures: [flights.count]
      filters:
        origin.state: CA
      width: 5
      height: 2
      
    - name: flights_by_departure_hour_lax
      type: area
      base_view: flights
      dimensions: flights.depart_hod
      measures: [flights.count, flights.late_count, flights.verylate_count]
      filters:
        flight.destination: LAX
      sorts: flights.depart_hod
      width: 8
      height: 4
      xAxisLabelsRotation: -45
      stacking: normal
      y_axis_combined: true

    - name: flight_count_comparison_of_california_vs_new_york_vs_texas
      type: pie
      base_view: flights
      dimensions: origin.state
      measures: flights.count
      filters:
        origin.state: CA,NY,TX
      width: 5
      height: 4

 
    - name: california_flights_by_california_destination
      type: pie
      base_view: flights
      dimensions: destination.city
      measures: flights.count
      filters:
        origin.state: CA
        destination.state: CA
      width: 6
      height: 5
      
    - name: flight_summary_stats
      type: table
      base_view: flights
      dimensions: [flights.depart_month]
      measures: [flights.count, flights.late_count, flights.verylate_count]
      width: 7
      height: 5

#     - name: top_5_carriers_by_accidents
#       type: column
#       base_view: accidents
#       dimension: accidents.air_carrier
#       measures: [accidents.count, accidents.total_fatalities]
#       filters:
#         accidents.air_carrier: -EMPTY
#       limit: 6
#       width: 8
#       height: 4
 
#  
#     - name: total_number_of_accidents
#       type: single_value
#       base_view: accidents
#       measure: accidents.count
#       filters:
#         accidents.air_carrier: -EMPTY
#       width: 5
#       height: 2
# 

