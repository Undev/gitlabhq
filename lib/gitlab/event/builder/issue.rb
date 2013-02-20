module Gitlab
  module Event
    module Builder
      class Issue < Gitlab::Event::Builder::Base
        include Gitlab::Event::Action::Issue

        class << self
          def can_build?(action, data)
            known_action = known_action? action
            # TODO Issue can be assigned to Milestone
            # TODO Issue can be refference to Issue
            known_sources = [::Issue, ::Note]
            known_source = known_sources.include? data.class
            known_source && known_action
          end

          def build(action, source, user, data)
            meta = parse_action(action)
            actions = []
            target = source

            case source
            when ::Issue

              actions << meta[:action]

              case meta[:action]
              when :created
                actions << :assigned if source.assignee_id_changed?
              when :updated
                changes = source.changes

                actions << :assigned if source.assignee_id_changed? && changes['assignee_id'].first.nil?
                actions << :reassigned if source.assignee_id_changed? && changes['assignee_id'].first.present?

                #TODO. Check, if Only closed/reopened - not make :updated event
              when :closed
              when :reopened
              when :deleted
              end

            when ::Note

              target = source.noteable

              if target.is_a? ::Issue
                case meta[:action]
                when :created
                  actions << :commented
                end
              end

            end

            events = []

            actions.each do |act|
              events << ::Event.new(action: ::Event::Action.action_by_name(act),
                                    source: source, data: data.to_json, author: user, target: target)
            end

            events
          end
        end
      end
    end
  end
end