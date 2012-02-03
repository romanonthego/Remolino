class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
  			 :registerable,
         :recoverable,
         #:rememberable,
         :trackable,
         :timeoutable,
         :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :patronomic, :last_name, :roles


  # References

  # This is self reference block - user can HAVE another users as his posible subtituents
  # for user who IS substituent on the other hand - user for whom hi substitute appears as appointive
  # so it works with simple reflection - but not goes both ways (user1 is sub for user2, but u2 may not be a sub for u1
  # while he WILL be apoointive for u1)

  # Simple (well, not simple actualy, takes time to figure it out) self reference - user can have many over user as substituents
  # self join goes through model Deputy, sine i need some logic and attr be place in this middleware
  has_many :deputies, :foreign_key => "appointive_id" #, :include => :sub
  has_many :subs, :class_name => "User", :through => :deputies, :foreign_key => "appointive_id"

  # Tricky part: since i can not find a way to use a named scope for a assocition :trought i create a new one. It basicly the 
  # same deputy association, but with conditions.
  # Also i change it from has_many to has_one - while user can have multiply posible subs, he can only have 1 active substituent
  has_one :active_deputy, :class_name => "Deputy", :foreign_key => "appointive_id", :conditions => {:is_active => true}
  has_one :active_sub, :class_name => "User", :through => :active_deputy, :foreign_key => "appointive_id", :source => :sub

  # All the same but in the opposite way. Thats why i call it reverse_ .
  has_many :reverse_deputies, :class_name => "Deputy", :foreign_key => "sub_id"
  has_many :appointives, :class_name => "User", :through => :reverse_deputies, :foreign_key => "sub_id"

  # has_many back again. Why? User can accept substituenship from many user simultaneously.
  has_many :active_reverse_deputies, :class_name => "Deputy", :foreign_key => "sub_id", :conditions => {:is_active => true}
  has_many :active_appointives, :class_name => "User", :through => :active_reverse_deputies, :foreign_key => "sub_id", :source => :appointive

  # Validations
  validates_presence_of :first_name 

  # Plugins, gems etc
  simple_roles
  # tango_user

  # Static methods
  
  # Instance methods
  def activate_sub(user)
    # rise an exception if given user is not User class instance
    dep = deputies.where(:sub_id => user.id).first
    dep.is_active = true
    dep.save!
  end

  def user_and_active_appointives
    UsersArray.new(self).extend_with_active_appointives
  end



  class UsersArray < Array

    attr_reader :base
    include UsersArrayExtension

    def initialize *args
      @user = args.delete(args.first)
      super
    end

    def extend_with_active_appointives
      self << @user
      self << @user.active_appointives
      self.flatten!
    end
  end


end
