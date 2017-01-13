class User < ActiveRecord::Base
  has_one :mailbox
  has_one :online
  has_many :sent_mails, :class_name => 'Mail' 

  alias_method :mails, :sent_mails

  validates :username, presence: true
  validates :password, presence: true
  validates :super, presence: true

end
