class Report < ApplicationRecord
  belongs_to :reporter, class_name: "User"
  belongs_to :reportee, class_name: "User"

  validates :reason,      presence: true
  validates :reporter_id, presence: true
  validates :reportee_id, presence: true
end
