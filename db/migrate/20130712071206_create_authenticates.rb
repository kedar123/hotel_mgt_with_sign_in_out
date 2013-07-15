class CreateAuthenticates < ActiveRecord::Migration
  def change
    create_table :authenticates do |t|

      t.timestamps
    end
  end
end
