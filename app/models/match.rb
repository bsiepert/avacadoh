class Match < ActiveRecord::Base
  belongs_to :tournament, class_name: Tournament
  belongs_to :sheet, class_name: PlayerSheet
  belongs_to :opponent, class_name: User
  attr_accessible :round, :tournament_id, :sheet_id, :opponent_id, :list_played, :won, :control_points, :army_points
end