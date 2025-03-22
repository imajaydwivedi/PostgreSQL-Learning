-- table index usage rates (should not be less than 0.99)
SELECT relname, case when  (seq_scan + idx_scan) = 0 then 0
                    else 100 * idx_scan / (seq_scan + idx_scan)
                    end percent_of_times_index_used,
        n_live_tup rows_in_table
FROM pg_stat_user_tables 
ORDER BY n_live_tup DESC;