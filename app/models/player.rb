class Player < ActiveRecord::Base

  scope :active, -> {where('players.id != -1')}

  def name
    [first_name, last_name].join(" ")
  end

end