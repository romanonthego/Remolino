require 'spec_helper'

describe User do

	before :each do
		@user = Factory(:user)
		@admin = Factory(:user)
		@economist = Factory(:user)
		@role_user = Factory(:role)
		@role_admin = Factory(:role, :name => "admin")
	end

	context "Basic user creation and validation" do
	 	it "creates new user" do
	 		@user
	 	end
  end

  context "Simple_roles managment" do
	 	it "new user should have no roles by default" do
	 		@user
	 		@user.roles.should == []
	 	end

	 	it "can assign user to a new roles" do
	 
	 		@user.add_role :user

	 		@user.is_user?.should == true
	 		@user.is_admin?.should == false
	 	end

	 	it "can assign user to multiplie roles" do
	 		@user.add_roles [:admin, :user]
	 		@user.is_admin?.should == true
	 		@user.is_user?.should == true
	 	end
	end

	context "CanCan basic testing" do 

	 	it "admin can manage memos..." do
	 		@user.add_role :admin
	 		ability = Ability.new(@user)
	 		ability.can?(:manage, Memo).should be_true
	 	end

	 	it "...but simple user can not - read_only" do
	 		@user.add_role :user
	 		ability = Ability.new(@user)
	 		ability.can?(:manage, Memo).should be_false
	 		ability.can?(:read, Memo).should be_true
	 	end
	end

	context "Substituents and Appointives" do
		it "user can have both subs and appointives" do
			@user.subs
			@user.appointives
		end

		it "both subs and appointives should be empty by default" do
			@user.subs.should == []
			@user.appointives.should == []
		end

		it "user can add another user as his substituent" do
			@admin.subs.should == []
			@admin.subs << @user
			@admin.subs.should include @user
			@admin.deputies.length.should == 1
		end

		it "then user is one user substituent is appears as another users appointive" do
			@admin.subs.should == []
			@admin.subs << @user
			@admin.subs.should include @user
			@user.appointives.should include @admin
			@user.appointives.length.should == 1
		end

		it "user can have many subs and only one active_sub" do
			@user1 = Factory(:user)
			@user2 = Factory(:user)

			@admin.subs.should == []
			@admin.subs << @user1
			@admin.subs << @user2
			@admin.subs.should include @user1, @user2
			@admin.activate_sub(@user1)
			@admin.active_sub.should == @user1
			@user1.active_appointives.should include @admin

		end
	end


	context "CanCan extended to cover active_appointives" do
		it "user can? halper extends with active_appointive abilities" do
			@user1 = Factory(:user)
			@user2 = Factory(:user)

			@user1.add_role :user
			@user2.add_role :user
			@admin.add_role :admin

			@admin.subs.should == []
			@admin.subs << @user1
			@admin.subs << @user2
			@admin.subs.should include @user1, @user2
			@admin.activate_sub(@user1)
			@admin.active_sub.should == @user1
			@user1.active_appointives.should include @admin

			extended_user = @user1.user_and_active_appointives
			extended_user.should include @admin, @user1

			extended_user.class.should == User::UsersArray

			extended_user.methods.should include :have_admin?
			extended_user.have_admin?.should == true

			ab = Ability.new(@user1)
			ab.can?(:manage, Memo).should be_true
		end
	end

end
