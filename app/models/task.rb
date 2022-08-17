class Task < ApplicationRecord
  validates :title, presence: true

  has_many :tagged_tasks, :dependent => :destroy
  has_many :tags, through: :tagged_tasks

  attribute :input_tags
  attribute :saved_tags

  def add_tags
    insert_tags(input_tags)
  end

  def update_tags
    input_tags.delete_if {|t| t.blank?}
    _saved_tags = saved_tags.dup
    remove_tags(_saved_tags - input_tags)
    insert_tags(input_tags - _saved_tags)
  end

  def insert_tags(ts)
    ts.each do |tag|
      if tag.present?
        TaggedTask.create!(task: self, tag: Tag.find(tag))
      end
    end
  end

  def remove_tags(ts)
    ts.each do |tag|
      if tag.present?
        tagged_tasks.destroy_by(tag_id: tag)
      end
    end
  end

  after_initialize do
    self.saved_tags = tags.collect(&:id).collect(&:to_s)
  end

  before_save do
    if self.due_date.blank?
      self.due_date = Date.today
    end
  end
end
