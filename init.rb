
if defined? Rails
  if defined? Facebooker
    require 'facebooker_plus/facebooker_plus'
    require 'facebooker_plus/rails/fb_sig_add'
    require 'facebooker_plus/rails/controller'
    require 'facebooker_plus/rails/helper'
    require 'facebooker_plus/extensions/active_record'
    require 'facebooker_plus/extensions/action_controller'
    require 'facebooker_plus/extensions/action_view'
    require 'facebooker_plus/extensions/session'
    
    FacebookerPlus::Base.init(defined?(config) ? config : nil)
    
  else
    STDERR.puts "** [FacebookerPlus] ERROR: Please load Facebooker before Facebooker Plus.\n"
  end
end