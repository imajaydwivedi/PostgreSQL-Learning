set search_path to postgres_air;

EXPLAIN (ANALYZE, VERBOSE, COSTS, FORMAT JSON, BUFFERS)
SELECT f.flight_no,
       f.actual_departure,
       count(passenger_id) passengers
  FROM flight f
       JOIN booking_leg bl ON bl.flight_id = f.flight_id
       JOIN passenger p ON p.booking_id=bl.booking_id
WHERE f.departure_airport = 'JFK'
   AND f.arrival_airport = 'ORD'
   AND f.actual_departure BETWEEN '2023-08-13' and '2023-08-14'
GROUP BY f.flight_id, f.actual_departure;