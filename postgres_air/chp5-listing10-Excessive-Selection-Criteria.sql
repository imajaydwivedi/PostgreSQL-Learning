set
    search_path to postgres_air;

--explain ANALYZE
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
SELECT
    last_name,
    first_name,
    seat
FROM
    boarding_pass bp
    JOIN booking_leg bl USING (booking_leg_id)
    JOIN flight f USING (flight_id)
    JOIN booking b USING(booking_id)
    JOIN passenger p USING (passenger_id)
WHERE
    (
        departure_airport = 'JFK'
        AND scheduled_departure BETWEEN '2020-07-10' AND '2020-07-11'
        AND last_name = 'JOHNSON'
    )
    OR (
        departure_airport = 'EDW'
        AND scheduled_departure BETWEEN '2020-07-13' AND '2020-07-14'
        AND last_name = 'JOHNSTON'
    );

/*
Nested Loop  (cost=15.25..1034.63 rows=1 width=15) (actual time=0.013..0.015 rows=0 loops=1)
  ->  Nested Loop  (cost=14.82..1033.27 rows=1 width=19) (actual time=0.013..0.014 rows=0 loops=1)
        Join Filter: (((f.departure_airport = 'JFK'::bpchar) AND (f.scheduled_departure >= '2020-07-10 00:00:00+05:30'::timestamp with time zone) AND (f.scheduled_departure <= '2020-07-11 00:00:00+05:30'::timestamp with time zone) AND (p.last_name = 'JOHNSON'::text)) OR ((f.departure_airport = 'EDW'::bpchar) AND (f.scheduled_departure >= '2020-07-13 00:00:00+05:30'::timestamp with time zone) AND (f.scheduled_departure <= '2020-07-14 00:00:00+05:30'::timestamp with time zone) AND (p.last_name = 'JOHNSTON'::text)))
        ->  Nested Loop  (cost=14.38..938.48 rows=37 width=27) (actual time=0.012..0.013 rows=0 loops=1)
              ->  Nested Loop  (cost=13.94..341.67 rows=26 width=20) (actual time=0.012..0.013 rows=0 loops=1)
                    ->  Bitmap Heap Scan on flight f  (cost=8.87..12.90 rows=1 width=16) (actual time=0.012..0.013 rows=0 loops=1)
                          Recheck Cond: (((scheduled_departure >= '2020-07-10 00:00:00+05:30'::timestamp with time zone) AND (scheduled_departure <= '2020-07-11 00:00:00+05:30'::timestamp with time zone)) OR ((scheduled_departure >= '2020-07-13 00:00:00+05:30'::timestamp with time zone) AND (scheduled_departure <= '2020-07-14 00:00:00+05:30'::timestamp with time zone)))
                          Filter: (((departure_airport = 'JFK'::bpchar) AND (scheduled_departure >= '2020-07-10 00:00:00+05:30'::timestamp with time zone) AND (scheduled_departure <= '2020-07-11 00:00:00+05:30'::timestamp with time zone)) OR ((departure_airport = 'EDW'::bpchar) AND (scheduled_departure >= '2020-07-13 00:00:00+05:30'::timestamp with time zone) AND (scheduled_departure <= '2020-07-14 00:00:00+05:30'::timestamp with time zone)))
                          ->  BitmapOr   (cost=8.87..8.87 rows=1 width=0) (actual time=0.011..0.011 rows=0 loops=1)
                                ->  Bitmap Index Scan on flight_scheduled_departure  (cost=0.00..4.43 rows=1 width=0) (actual time=0.008..0.008 rows=0 loops=1)
                                      Index Cond: ((scheduled_departure >= '2020-07-10 00:00:00+05:30'::timestamp with time zone) AND (scheduled_departure <= '2020-07-11 00:00:00+05:30'::timestamp with time zone))
                                ->  Bitmap Index Scan on flight_scheduled_departure  (cost=0.00..4.43 rows=1 width=0) (actual time=0.002..0.002 rows=0 loops=1)
                                      Index Cond: ((scheduled_departure >= '2020-07-13 00:00:00+05:30'::timestamp with time zone) AND (scheduled_departure <= '2020-07-14 00:00:00+05:30'::timestamp with time zone))
                    ->  Bitmap Heap Scan on booking_leg bl  (cost=5.07..327.96 rows=82 width=12) (never executed)
                          Recheck Cond: (flight_id = f.flight_id)
                          ->  Bitmap Index Scan on booking_leg_flight_id  (cost=0.00..5.05 rows=82 width=0) (never executed)
                                Index Cond: (flight_id = f.flight_id)
              ->  Index Scan using boarding_pass_booking_leg_id on boarding_pass bp  (cost=0.44..22.72 rows=23 width=19) (never executed)
                    Index Cond: (booking_leg_id = bl.booking_leg_id)
        ->  Index Scan using passenger_pkey on passenger p  (cost=0.43..2.53 rows=1 width=16) (never executed)
              Index Cond: (passenger_id = bp.passenger_id)
              Filter: ((last_name = 'JOHNSON'::text) OR (last_name = 'JOHNSTON'::text))
  ->  Index Only Scan using booking_pkey on booking b  (cost=0.43..1.35 rows=1 width=8) (never executed)
        Index Cond: (booking_id = bl.booking_id)
        Heap Fetches: 0
Planning Time: 1.780 ms
Execution Time: 0.369 ms
*/