class OnlineFile < ActiveRecord::Base

  validates :from, presence: true
  validates :to, presence: true
  validates :filename, presence: true

end
