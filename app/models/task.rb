class Task < ApplicationRecord
  validates :title, presence: true

  before_save do
    if self.due_date.blank?
      self.due_date = Date.today
    end
  end
end
