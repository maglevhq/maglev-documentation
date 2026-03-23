---
title: Secure the editor
order: 5
---

# Secure the editor

The Maglev engine does not depend on a specific authentication gem such as [Devise](https://github.com/heartcombo/devise).

The tradeoff is that **your app** must tell Maglev whether the **current user** may open the editor.

Maglev has two areas that matter for access control: the **Editor UI** and the **Admin UI**. They use different authentication hooks.

## Editor UI authentication

You can wire editor access in either of these ways:

* pass **`config.is_authenticated`** a **symbol** naming a method available on your controllers, or
* pass a **Proc** evaluated in the Maglev editor controller context (it does **not** inherit from your `ApplicationController` the same way a normal app controller does—check the engine if you rely on helpers).

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

Both forms must return a boolean (whether the user may use the editor). A **`Proc`** is usually called with the Maglev **`site`** as its first argument, as in the commented example above.

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

### Example: very simple authentication system

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

## Admin UI authentication

By default, the Admin UI is available without any credentials in the development and test environments.

In production, set a **username** and **password** in the Maglev config, for example:

{% code title="config/initializers/maglev.rb" %}
```ruby
Maglev.configure do |c|
  ...
  # Admin UI authentication (see Secure the editor guide)
  config.admin_username = Rails.env.production? ? ENV.fetch('MAGLEV_ADMIN_USERNAME') : nil
  config.admin_password = Rails.env.production? ? ENV.fetch('MAGLEV_ADMIN_PASSWORD') : nil
  ...
end
```
{% endcode %}
