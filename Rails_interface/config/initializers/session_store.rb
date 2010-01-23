# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Rails_interface_session',
  :secret      => '86871615b032d71cb6daf397285114e61d748caadce113117e7d36982d43d0145db71110b350910d00e45cfb8bab7815f85b8edc3b01e1e1dc1dbaaa2d6d2c95'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
