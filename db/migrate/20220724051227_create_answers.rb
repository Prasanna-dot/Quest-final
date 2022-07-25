class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.string :user_answer
      t.boolean :status

      t.timestamps
    end
  end
end
