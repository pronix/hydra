# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_hy_session',
  :secret      => '6f6d755675627f947fa5e32be4e38be4d3e66175c4b75720144ea1d378fbb2c096ac33ca0e982fbbdcf20151e342568f01dee2838668d0b44529ea1d8e15ce4c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
