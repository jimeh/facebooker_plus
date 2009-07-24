# Facebook uses some non alphanum characters in the session
# identifier which interfere with memcache stored sessions.
class CGI
  class Session
    class MemCacheStore
      def check_id(id) #:nodoc:#
        /[^0-9a-zA-Z\-\._]+/ =~ id.to_s ? false : true
      end
    end
  end
end