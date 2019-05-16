class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :sender_id
      t.integer :reciever_id
      t.string :message_body
      t.timestamps
    end
  end
end
