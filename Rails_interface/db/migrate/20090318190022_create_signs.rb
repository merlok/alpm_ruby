class CreateSigns < ActiveRecord::Migration
  def self.up
    create_table :signs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :signs
  end
end
