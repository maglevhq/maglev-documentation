---
title: Secure the editor
order: 5
---

# Secure the editor

In the Maglev Rails engine, we managed to avoid relying on any specific authentication system such as [Devise](https://github.com/heartcombo/devise). 

The counter part is this is now up to the developer installing Maglev to let Maglev know if the current user of his application has the rights to access the Editor UI.

There are 2 major UI parts in Maglev: the Editor UI and the Admin UI. Those 2 parts don't require the same authentication mechanism.

### Editor UI authentication

You, as the developer, can pick one of the 2 ways of verifying whether the current user of the main application is allowed or not to access the Editor UI.

* either you pass the name of a method globally available 
* or you pass a Proc that will be executed in the context of the Maglev::EditorUI controller which inherits not directly from the ApplicationController class of the main application.

{% code title="config/initializers/maglev.rb" %}
```ruby
Maglev.configure do |c|
  ...
  # config.is_authenticated = :editor_allowed? # name of any protected method from your Rails application controller
  # config.is_authenticated = ->(site) { current_user&.role == 'editor' }
  ...
end
```
{% endcode %}

Both of those 2 solutions take the Maglev site as the first argument and they must return a boolean.

If false is returned, Maglev will raise an exception that the ApplicationController can rescue from like in the following example:

{% code title="app/controllers/application_controller.rb" %}
```ruby
class ApplicationController < ActionController::Base
  rescue_from Maglev::Errors::NotAuthorized, with: :unauthorized_maglev
  private
  def unauthorized_maglev
    flash[:error] = "You're not authorized to access the Maglev editor!"
    redirect_to sign_in_user_path # use your own url
  end
end
```
{% endcode %}

#### Example: very simple authentication system

For simple projects, installing a gem like Devise can be a little cumbersome. So, here is a very simple way to still protect the editor UI.

First, modify your Maglev config file:

{% code title="config/initializers/maglev.rb" %}
```ruby
Maglev.configure do |configure|
  ...
  config.is_authenticated = :authenticate_maglev_editor
  config.back_action = ->(site) { redirect_to 'https://www.nocoffee.fr', status: 401 }
  ...
end
```
{% endcode %}

The final step is to modify the ApplicationController of your main Rails application:

{% code title="app/controllers/application_controller.rb" %}
```ruby
class ApplicationController < ActionController::Base
  ...

  protected

  def authenticate_maglev_editor(site)
    http_basic_authenticate_or_request_with(
      name: ENV.fetch('MAGLEV_EDITOR_USERNAME'), 
      password: ENV.fetch('MAGLEV_EDITOR_PASSWORD'),
    )
  end
end

```
{% endcode %}

{% hint style="info" %}
Of course, you will have to set 2 new **ENV variables** in your project: `MAGLEV_EDITOR_USERNAME` and `MAGLEV_EDITOR_PASSWORD`.
{% endhint %}

### Admin UI authentication

By default, the Admin UI is available without any credentials in the development and test environments. 

In production, it will require an username and password that can defined in the Maglev config file like this:

{% code title="config/initializers/maglev.rb" %}
```ruby
Maglev.configure do |c|
  ...
  # Admin UI authentication (https://docs.maglev.dev/guides/authentication)
  config.admin_username = Rails.env.production? ? ENV.fetch('MAGLEV_ADMIN_USERNAME') : nil
  config.admin_password = Rails.env.production? ? ENV.fetch('MAGLEV_ADMIN_PASSWORD') : nil
  ...
end
```
{% endcode %}
