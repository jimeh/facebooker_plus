class FacebookerPlusController < ApplicationController
  
  before_filter :init_vars
  
  def init_vars
    @request_path = (!params[:request_path].nil?) ? URI::escape(params[:request_path], "/=!?&") : URI::escape("/", "/=!?&")
    @canvas = Facebooker.facebooker_config["canvas_page_name"]
    @canvas_url = "http://apps.facebook.com/" + @canvas
  end
  
  def parent_redirect_to(*args)
    if request_is_facebook_iframe?
      @redirect_url = url_for(*args)
      render :layout => false, :inline => <<-HTML
        <html><head>
          <script type="text/javascript">  
            window.parent.location.href = <%= @redirect_url.to_json -%>;
          </script>
          <noscript>
            <meta http-equiv="refresh" content="0;url=<%=h @redirect_url %>" />
            <meta http-equiv="window-target" content="_parent" />
          </noscript>
        </head></html>
      HTML
    else
      redirect_to(*args)
    end
  end
  
end