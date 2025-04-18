class Proposal < ApplicationRecord
  belongs_to :user
  has_many :negotiations
end
