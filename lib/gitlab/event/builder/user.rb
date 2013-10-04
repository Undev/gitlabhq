class Gitlab::Event::Builder::User < Gitlab::Event::Builder::Base
  class << self
    def prioritet
      6
    end

    def can_build?(action, data)
      known_action = known_action? action, ::User.available_actions
      known_sources = [::User, ::TeamUserRelationship, ::UsersProject, ::Key]
      known_source = known_sources.include? data.class
      known_source && known_action
    end

    def build(action, source, user, data)
      meta = Gitlab::Event::Action.parse(action)
      changes = source.changes
      temp_data = data.attributes

      actions = []

      case source
      when ::User
        target = source

        case meta[:action]
        when :created
          actions << :created
        when :blocked
          actions << :blocked
          temp_data["teams"] = source.teams.map { |t| t.attributes }
          temp_data["projects"] = source.projects.map { |pr| pr.attributes }
        when :activate
          actions << :activate
        when :updated
          unless ban_action?(changes)
            actions << :updated
            temp_data["previous_changes"] = changes
          end
        when :deleted
          actions << :deleted
        end

      when ::Key
        target = source.user

        case meta[:action]
        when :created
          actions << :added
        when :updated
          actions << :updated
        when :deleted
          actions << :deleted
        end
      when ::UsersProject
        target = source.user

        case meta[:action]
        when :created
          actions << :joined
        when :updated
          actions << :updated
          temp_data["previous_changes"] = changes
        when :deleted
          actions << :left
        end
      when ::TeamUserRelationship
        target = source.user

        case meta[:action]
        when :created
          actions << :joined
        when :updated
          actions << :updated
          temp_data["previous_changes"] = changes
        when :deleted
          actions << :left
        end
        # TODO.
        # Add support with Issue, MergeRequest, Milestone, Note, ProjectHook, ProtectedBranch, Service, Snippet
        # All models, which contain User
      end

      events = []

      actions.each do |act|
        events << ::Event.new(action: act,
                              source: source, data: temp_data.to_json, author: user, target: target)
      end

      events
    end

    def ban_action?(changes)
      changes["state"]
    end
  end
end
