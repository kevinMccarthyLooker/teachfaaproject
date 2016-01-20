- view: aircraft_flights_facts
  derived_table:
    sql: |
      SELECT
        f.tail_num AS tail_num
        , SUM(f.distance) AS lifetime_distance
        , COUNT(*) AS lifetime_flights
      FROM ontime AS f
      GROUP BY tail_num
    sortkeys: [tail_num]
    persist_for: 2000 hours

  fields:
    - dimension: tail_num
      primary_key: true
    
    - dimension: lifetime_distance
      type: int
    
    - dimension: lifetime_flights
      type: int
    
    - dimension: distance_per_flight
      type: number
      decimals: 2
      sql: 1.0 * ${lifetime_distance}/NULLIF(${lifetime_flights},0)
    
    - dimension: lifetime_distance_tier
      type: tier
      tiers: [0,1000000,2000000,3000000,4000000,5000000,7500000]
      sql: ${lifetime_distance}
    
    - dimension: lifetime_flights_tier
      type: tier
      tiers: [0,1000,2000,5000,10000,15000]
      sql: ${lifetime_flights}
    
    - dimension: distance_per_flight_tier
      type: tier
      tiers: [0,250,500,750,1000,1500]
      sql: ${distance_per_flight}