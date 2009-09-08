module FacebookerPlus
  module Rails
    module Controller
      # hook 
      def self.included(controller)
        controller.extend ClassMethods
        
        view_path = File.join(File.dirname(__FILE__), 'app', 'views')
        if controller.public_methods.include? 'append_view_path'  # rails 2.1+
          controller.append_view_path view_path
        elsif controller.public_methods.include? "view_paths"     # rails 2.0+
          controller.view_paths << view_path
        else                                                      # rails <2.0
          controller.template_root = view_path
        end
        
        controller.rescue_from Facebooker::Session::SessionExpired, :with => :rescue_and_kill_facebook_session
        controller.rescue_from Facebooker::Session::IncorrectSignature, :with => :rescue_and_kill_facebook_session
        controller.rescue_from Facebooker::Session::SignatureTooOld, :with => :rescue_and_kill_facebook_session
        
      end
      
      # ---------------------------------------------------------------
      # Before Filters
      # ---------------------------------------------------------------
      
      def set_facebooker_plus_options(options = {})
        @facebooker_plus_options = {}
        options.each do |key, value|
          @facebooker_plus_options[key] = value
        end
      end
      
      # ensure IE accepts cookies from within iframes
      def send_p3p_headers
        if !params[:fb_sig_in_iframe].blank? 
          headers['P3P'] = 'CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"'
        end
      end
      
      # ensure that xfb_sig* params are renamed to fb_sig*
      def ensure_parameters_are_chopped(chopment = 'x', match = 'fb_sig')   
        params.each do |key, value|
          if key.index(chopment + match) == 0
            params[key.sub(chopment, "").to_sym] = value
            params.delete(key)
          end
        end
      end

      # make sure facebooker is configured properly
      def apply_facebooker_options(options = {})
        @facebook_app = {:is_multi_app => false}
        if @facebooker_plus_options.has_key?(:app_class)
          app_model = @facebooker_plus_options[:app_class].constantize
          app = app_model.find_by_fb_app_id!(params[:fb_sig_app_id] || session[:app_id]) rescue nil
          if app
            Facebooker.apply_configuration(app.attributes)
            @facebook_app[:is_multi_app] = true
          end
        end
        Facebooker.facebooker_config.each do |key, value|
          @facebook_app[key.to_sym] = value
        end
      end
      
      # a one line comment is too short to explain what and why this code is about...
      def create_session_cookie_if_needed
        if !params[:fb_sig_in_iframe].blank? && cookies[ActionController::Base.session_options[:key]].nil?
          @handle_url = url_for("/fb_session/set?request_path=" + URI::escape(non_fb_params, "/=!?&"))
          render :layout => "fb_session", :template => "fb_session/cookie_handling"
        end
      end


      # ---------------------------------------------------------------
      # Overloads
      # ---------------------------------------------------------------

      def url_for(options = {})
        fb_sig_add(super(options)) rescue super(options)
      end

      def redirect_to_full_url(url, status)
        super(fb_sig_add(url), status) and return
      end
      
      
      # ---------------------------------------------------------------
      # Exception Rescuing
      # ---------------------------------------------------------------
      
      def rescue_and_kill_facebook_session
        redirect_to "/fb_session/reset"
      end
      
      
      # ---------------------------------------------------------------
      # Internals
      # ---------------------------------------------------------------
      
      def non_fb_params
        custom_params = []
        params.each do |key, value|
          custom_params << key.to_s + "=" + value.to_s if !key.to_s.match(/^(fb\_sig|controller|action|id)/)
        end
        custom_params = custom_params.join("&")
        custom_params = "?" + custom_params if !custom_params.blank?
        request.path + custom_params
      end

      
      # ---------------------------------------------------------------
      # Class Methods
      # ---------------------------------------------------------------
      
      module ClassMethods
        
        def init_facebooker_plus(options = {})
          before_filter { |controller| controller.set_facebooker_plus_options(options) }
          before_filter :send_p3p_headers
          before_filter :ensure_parameters_are_chopped
          before_filter :create_session_cookie_if_needed
          before_filter :apply_facebooker_options
        end
        
        def skip_facebooker(options = {})
          skip_before_filter :ensure_authenticated_to_facebook, options
          skip_before_filter :ensure_application_is_installed_by_facebook_user, options
        end
        
        def skip_facebooker_plus(options = {})
          skip_before_filter :create_session_cookie_if_needed, options
          skip_before_filter :configure_facebooker, options
        end
        
      end
      
      
    end
  end
end