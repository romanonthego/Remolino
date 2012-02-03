module UsersArrayExtension
	module ClassMethods
		def register_roles_methods
			valid_roles = SimpleRoles::Configuration.valid_roles
			valid_roles.each do |role|

				define_method :"have_#{role}?" do
          self.select{|u| u.roles.include?(:"#{role}")}.any?
        end

        # alias_method :"is_#{role}?", :"#{role}?"

			end
		end
	end
	
	module InstanceMethods
		
	end
	
	def self.included(receiver)
		receiver.extend         ClassMethods
		receiver.send :include, InstanceMethods
		receiver.register_roles_methods
	end
end