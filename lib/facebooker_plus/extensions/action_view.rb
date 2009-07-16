if Object.const_defined?(:Rails)
  ActionView::Base.send(:include, FacebookerPlus::Rails::FbSigAdd)
  ActionView::Base.send(:include, FacebookerPlus::Rails::Helper)
end