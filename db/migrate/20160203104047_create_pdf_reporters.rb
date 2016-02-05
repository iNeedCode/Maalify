class CreatePdfReporters < ActiveRecord::Migration
  def change
    create_table :pdf_reporters do |t|
      t.string :name
      t.text :members, array: true, default: []

      t.timestamps null: false
    end
  end
end
