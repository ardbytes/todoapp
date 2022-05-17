class Task 
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :title, :description, :due_date

  def persisted?
    false
  end
end
