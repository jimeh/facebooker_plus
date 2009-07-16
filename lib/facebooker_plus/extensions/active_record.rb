# Extend the models, do it here so that init.rb is cleaner

# If you want to externd your app, game whatever model just put "extend_application_with_facebooker_plus"
require 'facebooker_plus/models/app'
ActiveRecord::Base.send(:include, FacebookerPlus::App)