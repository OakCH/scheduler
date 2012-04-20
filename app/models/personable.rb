module Personable
  def self.included(base)
    base.has_one :user, :as => :personable, :autosave => true
    base.alias_method_chain :user, :autobuild
    
    base.extend ClassMethods
    base.define_user_accessors
  end
  
  def user_with_autobuild
    user_without_autobuild || build_user
  end
  
  def method_missing(meth, *args, &blk)
    user.send(meth, *args, &blk)
  rescue NoMethodError
    super
  end

end
