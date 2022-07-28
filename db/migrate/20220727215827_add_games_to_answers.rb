class AddGamesToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_reference :answers, :games, null: false, foreign_key: true
  end
end
