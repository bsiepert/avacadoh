class AvacadohUser < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email_address

end