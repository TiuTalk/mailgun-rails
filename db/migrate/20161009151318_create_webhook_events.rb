class CreateWebhookEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :webhook_events do |t|
      t.string :event
      t.string :recipient
      t.string :token
      t.datetime :timestamp

      t.timestamps
    end
  end
end
