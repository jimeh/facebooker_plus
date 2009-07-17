# This module will eventually be expanded as we figure out how facebooker_plus
# needs to work.

# Put "extend_application_with_facebooker_plus" in your App model to include the
# built-in methods of facebooker_plus.
module FacebookerPlus
  module App
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      
      def extend_application_with_facebooker_plus
        include FacebookerPlus::App::InstanceMethods
        extend  FacebookerPlus::App::SingletonMethods
      end
      
    end

    module SingletonMethods
      
      def retrieve_app(app_id)
        find_by_fb_app_id!(app_id) rescue nil
      end
      
    end

    module InstanceMethods
      
    end
  end
end