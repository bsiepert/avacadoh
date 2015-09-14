class Player < ActiveRecord::Base

  scope :active, -> {where('id != -1')}
  def name
    [first_name, last_name].join(" ")
  end

  def points
    matches.select {|m| m.winner == self}.count
  end

  def matches
    Match.where('p1_id = ? OR p2_id = ?', id, id)
  end
  
end