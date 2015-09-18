class AddEventsAndRegistrations < ActiveRecord::Migration
  def change
    create_table(:events, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8') do |t|
      t.column :pg_id, :integer
      t.column :name, :string
      t.column :location, :string
      t.column :description, :string
      t.column :date, :datetime
      t.timestamps
    end
      create_table :registrations, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
        t.column :player_id, :integer
        t.index :player_id
        t.column :event_id, :integer
        t.index :event_id
        t.column :active, :boolean
      end
  end
end
