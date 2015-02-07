OAUTH_CONFIG = YAML.load_file("#{Rails.root}/config/omniauth.yml")

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, OAUTH_CONFIG[:github][:client_id], OAUTH_CONFIG[:github][:client_secret], scope: "user:email"
end
