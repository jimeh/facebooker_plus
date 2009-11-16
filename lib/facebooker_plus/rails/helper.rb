module FacebookerPlus
  module Rails
    module Helper
      
      def url_for(options = {})
        options.is_a?(Hash) ? super(options) : fb_sig_add(super(options)) 
      end

      #FIXME make sure this works when using a hash as action URL
      # It throws an error saying that << is undefined for fb_sig_add or sth to that effect
      def form_for(record_or_name_or_array, *args, &proc)
        args[0][:url] = fb_sig_add(args[0][:url]) if !args[0][:url].nil?
        super(record_or_name_or_array, *args, &proc)
      end

      def button_to(name, options = {}, html_options = {})
        options = fb_sig_add(options) if options.is_a?(String)
        if html_options[:method] == :get || html_options[:method] == 'get'
          output = ''
          fb_params.each do |fb_param|
            output << "<input type=\"hidden\" name=\"x#{fb_param[0].to_s}\" value=\"#{fb_param[1].to_s}\" /> "
          end
          match = /\<form (.+?) class\=\"button-to\"\>(.+)/
          return super(name, options, html_options).gsub(match, '<form \1 class="button-to"> ' << output << '\2')
        end
        super(name, options, html_options)
      end
      
    end
  end
end
