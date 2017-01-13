class Online_file < ActiveRecord::Base

  validates :from, presence: true
  validates :to, presence: true
  validates :filename, presence: true

end
