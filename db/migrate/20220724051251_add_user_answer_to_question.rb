# frozen_string_literal: true

class AddUserAnswerToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_reference :answers, :question, null: false, foreign_key: true
  end
end
