# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_hfc_session',
  :secret      => '33bc20b1ec4c76f07a0698d3d2a7903018b5d05051b86b293d4f810b895a0ffa60174ac83ef90aeae20ba99fb9aedba7bbaf269c81560578392ebd20ae813d2b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
