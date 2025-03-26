/*
-- Changes for PostgreSQL.conf

logging_collection = on
log_destination = 'stderr'
log_directory = 'log'
#log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_filename = 'postgresql-%a.log'
log_rotation_age = '1d'
log_rotation_size = '50MB'

log_min_messages = 'info'
client_min_messages = 'debug1'

log_min_duration_statement = '5s'
log_min_duration_sample = '2s'
log_min_sample_rate = 0.1
log_transactions_sample_rate = 0.1

*/

