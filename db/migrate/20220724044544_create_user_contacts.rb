# frozen_string_literal: true

class CreateUserContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :user_contacts do |t|
      t.bigint :mobile
      t.string :website
      t.string :linkedin
      t.string :behance
      t.string :instagram
      t.string :github

      t.timestamps
    end
  end
end
