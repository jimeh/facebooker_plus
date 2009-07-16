
module FacebookerPlus
  
  class Base
    
    def self.init(rails_config)
      controller_path = File.join(facebooker_plus_root, 'lib', 'facebooker_plus', 'rails', 'app', 'controllers')
      helper_path = File.join(facebooker_plus_root, 'lib', 'facebooker_plus', 'rails', 'app', 'helpers')
      $LOAD_PATH << controller_path
      $LOAD_PATH << helper_path
 
      if defined? ActiveSupport::Dependencies
        ActiveSupport::Dependencies.load_paths << controller_path
        ActiveSupport::Dependencies.load_paths << helper_path
      elsif defined? Dependencies.load_paths
        Dependencies.load_paths << controller_path
        Dependencies.load_paths << helper_path
      else
        to_stderr "ERROR: Rails version #{(RAILS_GEM_VERSION) ? RAILS_GEM_VERSION : ''} too old."
        return
      end
    
      # If we have the config object then add the controller path to the list.
      # Otherwise we have to assume the controller paths have already been
      # set and we can just append newrelic.
      if rails_config
        rails_config.controller_paths << controller_path
      else
        current_paths = ActionController::Routing.controller_paths
        if current_paths.nil? || current_paths.empty?
          to_stderr "WARNING: Unable to modify the routes in this version of Rails.  Developer mode not available."
        end
        current_paths << controller_path
      end
    end
  
    def self.facebooker_plus_root
      File.expand_path(File.join(__FILE__, "..","..",".."))
    end
  
    def self.to_stderr(msg)
      STDERR.puts "** [FacebookerPlus] " + msg 
    end
  
  end
  
end