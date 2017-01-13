class Code < ActiveRecord::Base
  belongs_to :user
  alias_method :from, :user
end
