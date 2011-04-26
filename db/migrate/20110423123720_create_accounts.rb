class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :username
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.integer :login_count

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end

