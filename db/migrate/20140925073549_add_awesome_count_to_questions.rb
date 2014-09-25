class AddAwesomeCountToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :awesome_count, :integer, :default => 0
  end
end
