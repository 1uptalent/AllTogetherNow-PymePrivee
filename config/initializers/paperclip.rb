if Rails.env.production?
  PAPERCLIP_STORAGE_OPTIONS = {:storage => :s3, 
                               :s3_credentials => "#{Rails.root}/config/s3.yml",
                               :bucket => "xgn",
                               :path => "/:style/:filename",
                               :url  => ":s3_eu_url"}
else
  PAPERCLIP_STORAGE_OPTIONS = {}
end

# FIX for european buckets
# http://techspry.com/ruby_and_rails/amazons-s3-european-buckets-and-paperclip-in-rails-3/

Paperclip.interpolates(:s3_eu_url) do |att, style|
    "#{att.s3_protocol}://s3-eu-west-1.amazonaws.com/#{att.bucket_name}/#{att.path(style)}"
end

module AWS
    module S3
        DEFAULT_HOST = "s3-eu-west-1.amazonaws.com"
    end
end