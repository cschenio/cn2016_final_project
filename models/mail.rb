class Mail < ActiveRecord::Base
  belongs_to :user
  belongs_to :mailbox
  belongs_to :mail_history
  scope :sent_from, ->(user) {where(user: user)}
  scope :sent_to, ->(user) {where(mailbox: user.mailbox)}
  scope :related_to, ->(user) {find_by_sql("#{sent_from(user).to_sql} UNION #{sent_to(user).to_sql}")}
 

  def receiver
    return mailbox.user
  end
  alias_method :sender, :user
  alias_method :from, :user
  alias_method :to, :receiver
end
