module ClassMethods
  def define_user_accessors
    all_attributes = User.content_columns.map(&:name)
    ignored_attributes = ['created_at', 'updated_at', 'personable_type']
    attributes_to_delegate = all_attributes - ignored_attributes
    attributes_to_delegate.each do |attrib|
      class_eval <<-RUBY
def #{attrib}
  user.#{attrib}
end

def #{attrib}=(value)
  self.user.#{attrib} = value
end

def #{attrib}?
  self.user.#{attrib}?
end
RUBY
end
end

end
