module RedmineTelegram
  module Patches
    module TokenPatch

      def self.apply
        Token.class_eval do
          if defined? add_action
            add_action :telegram, max_instances: 1, validity_time: Proc.new {Token.validity_time}
          end
        end
      end
    end
  end
end
