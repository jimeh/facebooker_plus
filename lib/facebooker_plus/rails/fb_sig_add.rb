module FacebookerPlus
  module Rails
    module FbSigAdd

      def fb_params
        params.reject { |key, value| key.to_s.match(/^fb\_sig/) == nil }
      end

      def fb_sig_add(url)
        #TODO Figure out if fb_sig* params are needed in single-app mode.
        return url if params["fb_sig_in_iframe"].blank? || !url.index(".facebook.com").nil?
        if anchor_pos = url.index("#")
          anchor = url[anchor_pos..url.length-1]
          url = url[0..anchor_pos-1]
        end
        query_string = ""
        fb_params.each do |key, value|
          value = value.to_f if value.is_a?(Time)
          value = "1" if value == true
          value = "0" if value == false
          query_string << "x" << key.to_s << "=" << value.to_s << "&"
        end
        query_string.chop!
        result  = url
        result << (!url.index("?").nil? ? "&" : "?")
        result << query_string
        result << anchor if !anchor.nil?
        result
      end

    end
  end
end