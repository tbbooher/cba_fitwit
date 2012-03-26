class Ckeditor::Picture < Ckeditor::Asset
  has_mongoid_attached_file :data,
                            :storage => :s3,
                            :s3_credentials => S3_CREDENTIALS,
                            :path => ":attachment/:id/:style_:basename.:extension",
                            :styles => { :content => '800>', :thumb => '118x100#' },
                            :default_url => "/images/avatars/:style/missing.png"

  validates_attachment_size :data, :less_than => 2.megabytes
  validates_attachment_presence :data

  def url_content
    url(:content)
  end
end
