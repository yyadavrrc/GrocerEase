class CreateHomes < ActiveRecord::Migration[7.1]
  def change
    create_table :homes do |t|
      t.string :heading
      t.text :message

      t.timestamps
    end
  end
end
