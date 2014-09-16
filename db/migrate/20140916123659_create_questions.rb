class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :name
      t.string :address
      t.string :college
      t.string :e_mail
      t.string :phone
      t.text :question

      t.timestamps
    end
  end
end
