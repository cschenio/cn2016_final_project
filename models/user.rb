class User < ActiveRecord::Base
  has_one :mailbox
  has_many :sent_mails, :class_name => 'Mail' 
  def hi
    "hi"
  end
  alias_method :mails, :sent_mails
end
