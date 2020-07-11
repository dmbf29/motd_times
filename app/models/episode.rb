class Episode < ApplicationRecord
  validates_uniqueness_of :date, scope: :show

  def set_in_past!
    self.past = true
    save
  end
end
