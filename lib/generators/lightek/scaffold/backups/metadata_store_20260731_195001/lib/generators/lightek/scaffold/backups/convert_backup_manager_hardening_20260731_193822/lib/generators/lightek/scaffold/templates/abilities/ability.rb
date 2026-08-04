can :read, <%= class_name %>

can [:create, :update, :destroy], <%= class_name %> do |record|
  user.admin?
end
