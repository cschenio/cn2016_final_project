class Online < ActiveRecord::Base

  belongs_to :user
  validates :user, presence: true 
  #validates :has_file, presence: true

end
