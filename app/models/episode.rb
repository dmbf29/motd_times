class Episode < ApplicationRecord
  validates_uniqueness_of :time

  def set_in_past!
    past = true
    save
  end
end
