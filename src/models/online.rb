class Online < ActiveRecord::Base

  belongs_to :user
  validates :user, presence: true 
  validates :has_file, inclusion: { in: [ true, false ] }
end
