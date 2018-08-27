class CreateTargets < ActiveRecord::Migration[5.2]
  def change
    create_table   :targets do |t|
      t.integer    :radius, :topic, null: false
      t.string     :title, null: false

      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
