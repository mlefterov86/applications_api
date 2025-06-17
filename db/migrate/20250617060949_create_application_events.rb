# frozen_string_literal: true

class CreateApplicationEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :application_events do |t|
      t.string :type
      t.text :content
      t.references :application, null: false, foreign_key: true

      t.timestamps
    end
  end
end
