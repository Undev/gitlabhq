module Gitlab
  module Event
    module Builder
      class Namespace < Gitlab::Event::Builder::Base
        @avaliable_action = [:created,
                             :deleted,
                             :updated,
                             :transfer
                            ]

        class << self
          def can_build?(action, data)
            known_action = known_action? @avaliable_action, action
            known_target = data.is_a? ::Namespace
            known_target && known_action
          end

          def build(data)
          end
        end
      end
    end
  end
end
