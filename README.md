# Facebooker Plus

A Ruby on Rails plugin fixing, extending and adding features to [Facebooker][1], possibly beyond the originally intended scope of Facebooker itself.

Originally the main focus was on iframe-based applications, meaning that canvas applications are pretty much completely untested. But we will be doing some testing soon to make sure everything works with canvas applications as well.

[1]: http://github.com/mmangino/facebooker/tree/master

* Adds optional support for running multiple applications by storing application configurations in the database.
* Adds a lot of customizations to make sure iframe based Facebook applications work properly.
	* Cookies are set properly in WebKit-based browsers which default to deny 3rd party cookies.
	* All helpers are overloaded to include the `fb_sig_*` params in all links, forms, button_to and more.
	* In the actual requested URLs `xfb_sig_*` is used instead to avoid issues with Facebook's invite forms which tend to strip the params from the URL, causing Facebooker to fail for iframe applications in browsers which don't accept third party cookies.

# Setup

### Install Plugin

    script/plugin install git://github.com/jimeh/facebooker_plus.git

### Use Memcache for Session storage

Due to third party cookies being blocked on some browsers, the default cookie storage for session data does not work when you're developing an iframe application. Instead you need to store the session data on the server. This can be done in a few different way, but the generally recommended method is to use memcached.

For this you will need to have memcached installed and working, and then simply add add the following to your `config/environment.rb` file:

    config.action_controller.session_store = :mem_cache_store

### Initiate Facebooker Plus in Your App

Simply place the following line of code in your ApplicationController, before Facebooker's `ensure_application_is_installed_by_facebook_user`:

    init_facebooker_plus

## Multi-App Mode

With Multi-App mode your one Rails application can easily run multiple different Facebook applications from a single code base. This is achieved by storing your Facebook configurations in the database. Typically in a table called "apps".

### Create Model and Migration

    script/generate model App

Modify the new migration that was created so it looks like this:

    class CreateApps < ActiveRecord::Migration
      def self.up
        create_table :apps do |t|
          t.column :fb_app_id, :bigint
          t.string :api_key
          t.string :secret_key
          t.string :name
          t.string :canvas_page_name  
          t.timestamps
        end
      end
      def self.down
        drop_table :apps
      end
    end

And then migrate:

    rake db:migrate

### Initialize Facebooker Plus

We need to tell Facebooker Plus that it's running in Muti-App mode. Do this by passing `:app_class` with a string value of the App model to `init_facebooker_plus`.

    init_facebooker_plus(:app_class => "App")

### Configuring Facebooker

Use your favorite database viewer/editor and add a new row to the `apps` table with all the correct information. If for any reason the current app's configuration is not stored in the database, the table doesn't exist, or any other problem, Facebooker will revert to using `config/facebooker.yml` for it's configuration.

## Skip Facebooker Plus and/or Facebooker for Certain Controllers

You can skip having Facebooker Plus and/or Facebooker run on certain controllers with two simple methods. This is useful if you wanna create a Welcome controller for example which displays some introduction pages to users before requesting them to add the application.

Add the following in the beginning of your controller:

    skip_facebooker
    skip_facebooker_plus

## Notes

There are probably lots of things that can be done in a better way than we currently are. Any and all suggestions, patches, and "zomg ur n00bs" statements are appreciated.

## License

(The MIT License)

Copyright (c) 2009 Jim Myhrberg & Panayiotis Papadopoulos.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
