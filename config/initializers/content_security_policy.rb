
Rails.application.config.content_security_policy do |policy|

    # This is for webpack-dev-server
    policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?
end