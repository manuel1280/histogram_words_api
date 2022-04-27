class CreateClientFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :client_files do |t|
      t.json :histogram_words
      t.timestamps
    end
  end
end
