module CoverPicture

  def self.included(base)
    base.extend CoverPicture::ClassMethods
  end

  module ClassMethods
    def has_cover_picture
      class_eval <<-EOV
        include Mongoid::Paperclip
        has_mongoid_attached_file :cover_picture,
                                  :storage => :s3,
                                  :s3_credentials => S3_CREDENTIALS,
                                  :path => ":attachment/:id/:style.:extension",
                                  :styles => {
                                    :popup  => "800x600=",
                                    :medium => "300x500>",
                                    :thumb  => "100x150>",
                                    :post_style => "450",
                                    :icon   => "64x90"
                                  },
                                  :default_url => "/images/avatars/:style/missing.png"
        # check if a picture exists. If you call <code>paperclip_field.url(:mode)</code>
        # paperclip will return <code>.../missing.png</code> at least and this is
        # always true. Use <code>cover_picture_exists?</code> to check if there
        # is a real picture there.
        def cover_picture_exists?
          cover_picture && !cover_picture.original_filename.blank?
        end
      EOV
    end

  end
end
