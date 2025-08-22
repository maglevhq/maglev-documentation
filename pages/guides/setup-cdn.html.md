---
title: Setup CDN
order: 6
---

# Setup CDN

A Content Delivery Network (CDN) is essential for optimizing your Maglev site's performance and user experience. This guide explains why using a CDN is crucial and how to configure it with Maglev.

## Why Use a CDN?

Using a CDN in front of your assets provides several key benefits:

* **Faster Loading Times**: CDNs serve assets from servers geographically closer to your users, reducing latency
* **Better Performance**: Static assets (images, CSS, JavaScript) are cached and served from edge locations
* **Reduced Server Load**: Your main server handles fewer asset requests, improving overall performance
* **Global Reach**: Users worldwide experience consistent, fast loading times
* **Cost Efficiency**: Reduced bandwidth costs and improved scalability

## How Maglev Handles CDNs

Maglev includes built-in CDN support through the `asset_host` configuration. When configured, Maglev automatically prepends the CDN URL to asset URLs, ensuring all assets are served through your CDN.

The `asset_host` configuration works with three different types of values:

* **String**: A static CDN URL
* **Proc**: A dynamic function that returns the CDN URL
* **Nil**: Falls back to the Rails application's `asset_host` value (default behavior and if defined)

{% hint style="info" %}
**Important Note**: Theme section screenshot URLs (displayed in the Maglev editor UI) are not handled by Maglev's `asset_host` configuration. These assets use the Rails application's `asset_host` configuration instead, as they are served through the main Rails application rather than the Maglev engine.
{% endhint %}

## CDN Configuration

### Static CDN URL

For simple setups with a single CDN endpoint:

{% code title="config/initializers/maglev.rb" %}
```ruby
Maglev.configure do |config|
  # ... other configuration ...

  # Static CDN URL
  config.asset_host = 'https://cdn.yourdomain.com'

  # ... other configuration ...
end
```
{% endcode %}

### Environment Variable Configuration

For flexible deployment across different environments, use environment variables:

{% code title="config/initializers/maglev.rb" %}
```ruby
Maglev.configure do |config|
  # ... other configuration ...

  config.asset_host = ENV['MAGLEV_CDN_URL']

  # ... other configuration ...
end
```
{% endcode %}

### Environment-Specific CDNs

{% code title="config/initializers/maglev.rb" %}
```ruby
Maglev.configure do |config|
  # ... other configuration ...

  config.asset_host = case Rails.env
                      when 'production'
                        'https://cdn.yourdomain.com'
                      when 'staging'
                        'https://staging-cdn.yourdomain.com'
                      when 'development'
                        nil
                      end

  # ... other configuration ...
end
```
{% endcode %}

### Dynamic CDN URL

For more complex setups where you need different CDNs per environment or site:

{% code title="config/initializers/maglev.rb" %}
```ruby
Maglev.configure do |config|
  # ... other configuration ...

  # Dynamic CDN URL based on environment
  config.asset_host = ->(site) do
    if Rails.env.production?
      "https://cdn.#{site.domain}"
    elsif Rails.env.staging?
      "https://staging-cdn.#{site.domain}"
    else
      nil # No CDN in development
    end
  end

  # ... other configuration ...
end
```
{% endcode %}

### Multi-Site CDN Support

{% code title="config/initializers/maglev.rb" %}
```ruby
Maglev.configure do |config|
  # ... other configuration ...

  config.asset_host = ->(site) do
    case site.domain
    when 'maindomain.com'
      'https://cdn.maindomain.com'
    else
      'https://default-cdn.com'
    end
  end

  # ... other configuration ...
end
```
{% endcode %}

## CDN Providers

### Popular CDN Services

* **Cloudflare**: Free tier available, excellent performance
* **AWS CloudFront**: Integrated with AWS services
* **BunnyCDN**: Cost-effective, high-performance
* **Fastly**: Enterprise-grade, real-time purging
* **KeyCDN**: Global network, competitive pricing

### Example: Cloudflare Setup

1. **Sign up for Cloudflare** and add your domain
2. **Configure DNS** to point to Cloudflare's nameservers
3. **Enable CDN** in the Cloudflare dashboard
4. **Configure Maglev** to use your Cloudflare domain:

{% code title="config/initializers/maglev.rb" %}
```ruby
Maglev.configure do |config|
  # ... other configuration ...

  config.asset_host = 'https://cdn.yourdomain.com'

  # ... other configuration ...
end
```
{% endcode %}

## Testing CDN Configuration

### Verify CDN is Working

1. **Check your Maglev configuration** to ensure `asset_host` is set
2. **Upload an image** through the Maglev editor
3. **Inspect the HTML** to verify the CDN URL is prepended
4. **Test asset loading** from different geographic locations

### Debug CDN Issues

If assets aren't loading through your CDN:

* Verify the `asset_host` configuration is correct
* Check that your CDN is properly configured
* Ensure DNS is pointing to your CDN
* Check CDN cache settings and purging

## Performance Optimization Tips

### CDN Best Practices

* **Use HTTPS**: Always serve assets over HTTPS for security
* **Set proper cache headers**: Configure appropriate cache expiration times
* **Enable compression**: Use gzip or brotli compression for text assets
* **Monitor performance**: Use tools like WebPageTest or Lighthouse
* **Purge cache strategically**: Only purge when necessary to maintain performance

### Cache Headers

Configure your CDN to set appropriate cache headers:

```
Cache-Control: public, max-age=31536000
```

This tells browsers to cache assets for one year, significantly improving performance for returning visitors.

## Troubleshooting

### Common Issues

**Assets not loading through CDN:**
* Check `asset_host` configuration
* Verify CDN is properly configured
* Ensure DNS is pointing to CDN

**Mixed content warnings:**
* Ensure all CDN URLs use HTTPS
* Check for any HTTP references in your content

**Cache invalidation:**
* Use CDN purging tools when updating assets
* Consider using cache-busting techniques for critical updates

### Getting Help

If you encounter issues with CDN setup:

* Check your CDN provider's documentation
* Verify Maglev configuration syntax
* Test with a simple static CDN URL first
* Consult the Maglev community for support

{% hint style="success" %}
A properly configured CDN can improve your Maglev site's loading speed by 50-80% and significantly enhance user experience, especially for international visitors.
{% endhint %}
