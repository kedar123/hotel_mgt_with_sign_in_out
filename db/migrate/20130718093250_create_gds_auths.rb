class CreateGdsAuths < ActiveRecord::Migration
  def change
    create_table :gds_auths do |t|

      t.timestamps
    end
  end
end
