class TaggedTask < ApplicationRecord
  belongs_to :tag
  belongs_to :task
end
