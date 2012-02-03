Factory.define :user do |f|
	# f.name "Robinson"
	f.sequence(:email) { |n| "email#{n}@test.com"}
	f.password "secret"
	f.first_name Faker::Name.name
	# f.deputies {|deputies| [deputies.association(:deputy)]}
	# f.subs {|subs| [subs.association(:subs)]}
end

Factory.define :role do |r|
	r.name "user"
end

Factory.define :deputy do |deputy|
	deputy.sub {|sub| sub.association(:sub)}
	deputy.appointive {|appointive| appointive.association(:appointive)}
	deputy.is_active false
end

Factory.define :reverse_deputy, :class => "Deputy" do |deputy|
	deputy.sub {|sub| sub.association(:sub)}
	deputy.appointive {|appointive| appointive.association(:appointive)}
end

Factory.define :sub, :class => User do |f|
	f.sequence(:email) { |n| "email#{n}@test.com"}
	f.password "secret"
	f.first_name "Robinson"
end
Factory.define :appointive, :class => User do |f|
	f.sequence(:email) { |n| "email#{n}@test.com"}
	f.password "secret"
	f.first_name "Robinson"
end