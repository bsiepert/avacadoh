class CreateModels < ActiveRecord::Migration
  def up
    create_table(:players, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8') do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :email_address, :string
      t.timestamps
    end
    create_table(:matches, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8') do |t|
      t.integer :round
      t.integer :event_id
      t.integer :p1_id
      t.integer :p2_id
      t.integer :p1_list_played
      t.integer :p2_list_played
      t.integer :p1_army_points
      t.integer :p2_army_points
      t.integer :p1_control_points
      t.integer :p2_control_points
      t.integer :winner_id
      t.timestamps
    end
  end

  def down
    drop_table :players
    drop_table :matches
  end
end
