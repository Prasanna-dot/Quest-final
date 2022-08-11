# frozen_string_literal: true

class AddUserToUserContact < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_contacts, :user, null: false, foreign_key: true
  end
end
