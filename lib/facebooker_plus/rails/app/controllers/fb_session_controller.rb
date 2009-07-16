class FbSessionController < FacebookerPlusController

  skip_facebooker_plus
  skip_facebooker
  
  def set
    redirect_to '/fb_session/check?request_path=' << @request_path
    return
  end

  def check
    if cookies[ActionController::Base.session_options[:key]].nil?     
      url = '/fb_session/force_set?' << request.query_string
      top_redirect_to(url)
      return
    else
      url = url_for(URI::unescape(@request_path))
      parent_redirect_to(url)
      return
    end
  end

  def force_set
    session[:session_force_set] = (session[:session_force_set].nil? || session[:session_force_set] > 2) ? 1 : session[:session_force_set] + 1
    if session[:session_force_set] > 1
      redirect_to @canvas_url << "/fb_session/enable_cookies"
      return
    else
      redirect_to @canvas_url << URI::unescape(@request_path)
      return
    end
  end

  def enable_cookies
    # static page informing user they must enable 3rd party cookies
  end
  
  def reset
    # rescue the SessionExpire, SignatureTooOld, and IncorrectSignature exceptions thrown by Facebooker.
    clear_fb_cookies!
    clear_facebook_session_information
    top_redirect_to @canvas_url
  end
  
end