class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.bigint :pin, unique: true
      t.string :status
      t.string :title
      t.string :time
      t.string :result

      t.timestamps
    end
  end
end
