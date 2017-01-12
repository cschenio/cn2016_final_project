class Code < ActiveRecord::Base
  belongs_to :user
  belongs_to :mailbox
  def receiver
    return mailbox.user
  end
  alias_method :sender, :user
  alias_method :from, :user
  alias_method :to, :receiver
end
