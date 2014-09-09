class AddKlarnaToAddress < ActiveRecord::Migration
  def change
    add_column(:spree_addresses, :p_no, :string)
    add_column(:spree_addresses, :gender, :integer)
  end
end
