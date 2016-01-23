class CreateReporters < ActiveRecord::Migration
  def change
    create_table :reporters do |t|
      t.string :name
      t.string :interval
      t.text :donations,  array: true, default: [], null:false
      t.text :tanzeems,   array: true, default: []
      t.text :emails,     array: true, default: [], null:false

      t.timestamps null: false
    end
  end
end
