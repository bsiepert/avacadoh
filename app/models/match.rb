class Match < ActiveRecord::Base
  belongs_to :event
  belongs_to :p1, class_name: Player, foreign_key:  'p1_id'
  belongs_to :p2, class_name: Player, foreign_key: 'p2_id'
  belongs_to :winner, class_name: Player, foreign_key: 'winner_id'

  validates :p1_army_points, :p2_army_points, :p1_control_points, :p2_control_points, :p1_list_played, :p2_list_played, :winner_id, presence: true

end