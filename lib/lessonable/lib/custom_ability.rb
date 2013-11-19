module Lessonable
  module CustomAbility
    private
      def add_custom_abilities(user)
        user.permissions.each do |permission|
          if permission.subject_id.nil?
            can permission.action.to_sym, permission.subject_class.constantize
          else
            can permission.action.to_sym, permission.subject_class.constantize, :id => permission.subject_id
          end
        end
      end
  end
end