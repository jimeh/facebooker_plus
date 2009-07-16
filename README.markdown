# Facebooker Plus

A Ruby on Rails plugin fixing, extending and adding features to [Facebooker][1], possibly beyond the originally intended scope of Facebooker itself.

[1]: http://github.com/mmangino/facebooker/tree/master

* Adds multi-application support by storing all application configuration in the database.
* Adds a lot of customizations to make sure iframe based Facebook applications work properly.
	* Cookies are set properly in WebKit-based browsers which default to deny 3rd party cookies.
	* All helpers are overloaded to include the _fb\_sig\_\*_ params in all links, forms, button\_to and more.
	* In the actual requested URLs _xfb\_sig\_\*_ is used instead to avoid issues with Facebook's invite forms which tend to strip the params from the URL, causing facebooker to fail for iframe applications in browsers which don't accept third party cookies.

WARNING: Completely untested with canvas applications.

## Install Plugin

Detailed instructions for n00bs are coming soon.

## Setup the Database

Run the following in your Rails project directory:

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

Edit app/models/app.rb, and add _extend\_application\_with\_facebooker\_plus_ like so:
 
    class App < ActiveRecord::Base
      extend_application_with_facebooker_plus
    end

## Initiate Facebooker Plus in your app

Simply place the following code in your ApplicationController:

    init_facebooker_plus

## Configuring Facebooker

Use your favorite database viewer/editor and add a new row to the _apps_ table with all the correct information.

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
