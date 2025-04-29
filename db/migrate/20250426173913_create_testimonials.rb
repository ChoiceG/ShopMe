class CreateTestimonials < ActiveRecord::Migration[8.0]
  def change
    create_table :testimonials do |t|
      t.string :name
      t.text :content
      t.boolean :approved

      t.timestamps
    end
  end
end
