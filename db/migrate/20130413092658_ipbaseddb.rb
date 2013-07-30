class Ipbaseddb < ActiveRecord::Migration
  def up
    
      create_table(:ipbasesdbs) do |t|
      ## Database authenticatable
      
      t.string :ipaddress
      t.string :dbname
        
      t.timestamps
      end
  end

  def down
  end
end
