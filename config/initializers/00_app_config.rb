raw_config = File.read("#{Rails.root}/config/app_config.yml")
APP_CONFIG = Hashie::Mash.new(YAML.load(raw_config)[Rails.env])