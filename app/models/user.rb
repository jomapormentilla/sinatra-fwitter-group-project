class User < ActiveRecord::Base
  has_secure_password
  has_many :tweets

  def slug
    self.username.downcase.gsub(/\W/," ").gsub(/\s+/," ").gsub(" ","-")
  end

  def self.find_by_slug( slug )
      self.all.each do |str|
          if str.slug == slug
              return str
          end
      end
  end
end
