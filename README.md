# Constant Cache

When your database has tables that store lookup data, there is a tendency 
to provide those values as constants in the model.  If you have an
account_statuses table with a corresponding model, your constants may look
like this:

    class AccountStatus
      ACTIVE   = 1
      PENDING  = 2
      DISABLED = 3
    end

There are a couple of problems with this approach:

As you add more lookup data to the table, you need to ensure that you're 
updating your models along with the data.  

The constants are stored as integer values and need to match up exactly 
with the data that's in the table (not necessarily a bad thing), but this
solution forces you to write code like this:

    Account.new(:username => 'preagan', :status => AccountStatus.find(AccountStatus::PENDING))

This requires multiple calls to find and obfuscates the code a bit.  Since classes
in Ruby are executable code, we can cache the objects from the database at load time
and use them in your application.

## Changes

### Major changes in version 0.2.0:

Split versions for DM and AR. For dm use: gem 'dm-constant-cache', '0.2.0', :require => 'constant\_cache'

### Major changes in version 0.1.0:

In order to support DataMapper as well as ActiveRecord, and to reduce dependencies
in the gem itself we've decided to make ConstantCache a module that must be included
in the class you wish to call cache_constants on. If you wish to have all AR classes
include the module, simply add an initializer to do ActiveRecord::Base.send(:include,
ConstantCache)

The cache now call #all instead of #find(:all) because it is supported by both ORMs.

The only other major change in the is a change in the method name #caches_constants
to #cache_constants (cache is a verb, implying an action or event)

## Installation

This code is packaged as a gem, so simply use the `gem` command to install:

    gem install constant_cache

## Example

"Out of the box," the constant_cache gem assumes that you want to use the 'name' column to generate
constants from a column called 'name' in your database table.  Assuming this schema:

    create_table :account_statuses do |t|
      t.string :name, :description
    end

    AccountStatus.create!(:name => 'Active',   :description => 'Active user account')
    AccountStatus.create!(:name => 'Pending',  :description => 'Pending user account')
    AccountStatus.create!(:name => 'Disabled', :description => 'Disabled user account')

We can use the plugin to cache the data in the table:

    class AccountStatus # uses ActiveRecord or DataMapper
      include ConstantCache
      
      cache_constants
    end

Now you can write code that's a little cleaner and not use multiple unnecessary find calls:

    Account.new(:username => 'preagan', :status => AccountStatus::PENDING)

If the column you want to use as the constant isn't 'name', you can set that in the model. If
we have :name, :slug, and :description, we can use 'slug' instead:

    class AccountStatus # uses ActiveRecord or DataMapper
      include ConstantCache
      
      cache_constants :key => :slug
    end
  
The value for the constant is truncated at 64 characters by default, but you can adjust this as
well:

    class AccountStatus # uses ActiveRecord or DataMapper
      include ConstantCache
      
      cache_constants :limit => 16
    end

## Acknowlegements

Thanks to Dave Thomas for inspiring me to write this during his Metaprogramming talk at a Rails Edge 
conference in early 2007.

Copyright (c) 2009 [Patrick Reagan](mailto:patrick.reagan@viget.com) and [Tony Pitale](mailto:tony.pitale@viget.com)
of Viget Labs, released under the MIT license
