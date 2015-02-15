class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
    
    Beer.select(:style).distinct.each { |s| Style.create(name:s[:style]) }
    rename_column :beers, :style, :old_style
    add_column :beers, :style_id, :integer
    Beer.all.each { |b| b.style_id = Style.find_by_name(b[:old_style]).id; b.save}
    remove_column :beers, :old_style
  end
end
