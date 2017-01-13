class Online < ActiveRecord::Base

  validates :username, presence: true
  validates :has_file, presence: true

end
