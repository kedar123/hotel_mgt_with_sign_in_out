# Be sure to restart your server when you modify this file.

HotelMgtWithWorkflowChanged::Application.config.session_store :cookie_store, key: '_hotel_mgt_with_workflow_changed_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
 HotelMgtWithWorkflowChanged::Application.config.session_store :active_record_store
