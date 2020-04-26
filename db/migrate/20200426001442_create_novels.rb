class CreateNovels < ActiveRecord::Migration[5.2]
  def change
    create_table :novels do |t|
      t.string :title
      t.text :outline
      t.text :content
      t.integer :parent_id
      t.integer :grandparent_id
      t.integer :fin, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
