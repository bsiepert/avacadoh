class AvacadohMatch < ActiveRecord::Base
  belongs_to :tournament, class_name: AvacadohTournament
  belongs_to :sheet, class_name: AvacadohPlayerSheet
  belongs_to :opponent, class_name: AvacadohUser
  attr_accessible :round, :tournament_id, :sheet_id, :opponent_id, :list_played, :won, :control_points, :army_points
end