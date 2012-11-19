class ContactRemovePendingAddSharingAndReceiving < ActiveRecord::Migration
  class Contact < ActiveRecord::Base; end

  def self.up
    add_column :contacts, :sharing, :boolean, :default => false, :null => false
    add_column :contacts, :receiving, :boolean, :default => false, :null => false

    if Contact.count > 0
      execute( <<SQL
        UPDATE contacts
          SET contacts.sharing = true, contacts.receiving = true
            WHERE contacts.pending = false
SQL
)

      execute( <<SQL
        DELETE user_preferences.* FROM user_preferences
          WHERE user_preferences.email_type = 'request_acceptance'
            OR user_preferences.email_type = 'request_received'
SQL
)
    end

    remove_index :contacts, [:person_id, :pending]
    remove_index :contacts, [:user_id, :pending]

    add_index :contacts, :person_id

    remove_column :contacts, :pending

  end

  def self.down

    remove_index :contacts, :person_id

    add_column :contacts, :pending, :default => true, :null => false
    add_index :contacts, [:user_id, :pending]

    add_index :contacts, [:person_id, :pending]

    execute( <<SQL
      UPDATE contacts
        SET contacts.pending = false
          WHERE contacts.receiving = true AND contacts.sharing = true
SQL
)

    remove_column :contacts, :sharing
    remove_column :contacts, :receiving
  end
end
