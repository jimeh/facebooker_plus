module ::ActionController
  class Base
    def self.inherited_with_facebooker_plus(subclass)
      inherited_without_facebooker_plus(subclass)
      if subclass.to_s == "ApplicationController"
        subclass.send(:include, FacebookerPlus::Rails::FbSigAdd)
        subclass.send(:include, FacebookerPlus::Rails::Controller)
      end
    end
    class << self
      alias_method_chain :inherited, :facebooker_plus
    end
  end
end