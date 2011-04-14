if Rails.env.production?
  PAPERCLIP_STORAGE_OPTIONS = {:storage => :s3, 
                               :s3_credentials => "#{Rails.root}/config/s3.yml",
                               :bucket => "xgn",
                               :path => "/:style/:filename"}
else
  PAPERCLIP_STORAGE_OPTIONS = {}
end