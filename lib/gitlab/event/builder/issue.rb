module Gitlab
  module Event
    module Builder
      class Issue < Gitlab::Event::Builder::Base

        @avaliable_action = [:created,    # +
                             :closed,     # +
                             :reopened,   # +
                             :deleted,    # +
                             :updated,    # +
                             :assigned,   # +
                             :reassigned, # +
                             :commented   # -
                            ]

        class << self
          def can_build?(action, data)
            known_action = known_action? @avaliable_action, action
            # TODO Issue can be assigned to Milestone
            # TODO Issue can be refference to Issue
            known_target = data.is_a? ::Issue
            known_target && known_action
          end

          def build(action, target, user, data)
            meta = parse_action(action)
            actions = []
            actions << meta[:action]
            case meta[:action]
            when :created
              actions << :assigned if target.assignee_changed?
            when :updated
              changes = target.changes

              actions << :assigned if target.assignee_changed? && changes['assignee'].first.nil?
              actions << :reassigned if target.assignee_changed? && changes['assignee'].first.present?

              actions << :closed if target.is_being_closed?
              actions << :reopened if target.is_being_reopened?
            when :deleted
            end

            events = []
            actions.each do |act|
              events << Event.build(action: action_by_name(act), target: target, data: data.to_json, author: user)
            end
          end
        end
      end
    end
  end
end
