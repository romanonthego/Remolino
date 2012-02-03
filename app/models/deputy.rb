class Deputy < ActiveRecord::Base
	# References
	belongs_to :appointive, :class_name => "User"
	belongs_to :sub, :class_name => "User"

end
