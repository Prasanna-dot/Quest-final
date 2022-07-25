class AddGameToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :game, null: false, foreign_key: true
  end
end
