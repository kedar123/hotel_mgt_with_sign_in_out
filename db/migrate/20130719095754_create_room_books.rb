class CreateRoomBooks < ActiveRecord::Migration
  def change
    create_table :room_books do |t|

      t.timestamps
    end
  end
end
