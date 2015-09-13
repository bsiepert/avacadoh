class Player < ActiveRecord::Base
  # has_many :p1_matches, foreign_key: 'p1_player_id'
  # has_many :p2_matches, foreign_key: 'p2_player_id'
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

  def has_played?(player_id)
    matches.any?{|m| m.p1_id == player_id || m.p2_id == player_id}
  end
end