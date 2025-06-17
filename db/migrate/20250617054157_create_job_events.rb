# frozen_string_literal: true

class CreateJobEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :job_events do |t|
      t.string :type
      t.references :job, null: false, foreign_key: true

      t.timestamps
    end
  end
end
