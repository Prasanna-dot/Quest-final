class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :question
      t.string :answer
      t.string :choice1
      t.string :choice2
      t.string :choice3

      t.timestamps
    end
  end
end
