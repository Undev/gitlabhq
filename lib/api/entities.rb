module API
  module Entities
    class User < Grape::Entity
      expose :id, :username, :email, :name, :bio, :skype, :linkedin, :twitter, :website_url,
             :theme_id, :color_scheme_id, :state, :created_at, :extern_uid, :provider
      expose :is_admin?, as: :is_admin
      expose :can_create_group?, as: :can_create_group
      expose :can_create_project?, as: :can_create_project
    end

    class UserSafe < Grape::Entity
      expose :name
    end

    class UserBasic < Grape::Entity
      expose :id, :username, :email, :name, :state, :created_at
    end

    class UserLogin < User
      expose :private_token
    end

    class Hook < Grape::Entity
      expose :id, :url, :created_at
    end

    class ProjectHook < Hook
      expose :project_id, :push_events, :issues_events, :merge_requests_events
    end

    class ForkedFromProject < Grape::Entity
      expose :id
      expose :name, :name_with_namespace
      expose :path, :path_with_namespace
    end

    class Project < Grape::Entity
      expose :id, :description, :default_branch
      expose :public?, as: :public
      expose :visibility_level, :ssh_url_to_repo, :http_url_to_repo, :web_url
      expose :owner, using: Entities::UserBasic
      expose :name, :name_with_namespace
      expose :path, :path_with_namespace
      expose :issues_enabled, :merge_requests_enabled, :wall_enabled, :wiki_enabled, :snippets_enabled, :created_at, :last_activity_at
      expose :namespace
      expose :forked_from_project, using: Entities::ForkedFromProject, :if => lambda{ | project, options | project.forked? }
    end

    class TargetSubscription < Grape::Entity
      expose :id do |subscription, options|
        subscription.target_id
      end

      expose :namespace do |subscription, options|
        if subscription.target.respond_to?(:namespace)
          subscription.target.namespace.human_name
        end
      end

      expose :name do |subscription, options|
        subscription.target.try(:name)
      end

      expose :link do |subscription, options|
        h = Rails.application.routes.url_helpers

        case subscription.target.class.name
          when 'Project'
            h.project_path(subscription.target)
          when 'Team'
            h.team_path(subscription.target)
          when 'Group'
            h.group_path(subscription.target)
          when 'User'
            h.user_path(subscription.target)
          else
            ''
        end
      end

      expose :options do |subscription, options|
        available_sources = subscription.target.class.watched_sources.map(&:to_s)
        sources = subscription.options

        available_sources.reduce({}) do |response, source|
          response[source] = sources.include?(source)
          response
        end
      end

      expose :adjacent do |subscription, options|
        target = subscription.target
        user = subscription.user

        if target.class.watched_adjacent_sources.any?
          adjacent = options[:user].auto_subscriptions.adjacent(target.class.name, target.id)
            .pluck(:target).map(&:to_sym)

          target.class.watched_adjacent_sources.reduce({}) do |response, source|
            response[source] = adjacent.include?(source)
            response
          end
        else
          {}
        end
      end
    end

    class ProjectMember < UserBasic
      expose :project_access, as: :access_level do |user, options|
        options[:project].users_projects.find_by(user_id: user.id).project_access
      end
    end

    class TeamMember < UserBasic
      expose :permission, as: :access_level do |user, options|
        options[:team].team_user_relationships.find_by(user_id: user.id).permission
      end
    end

    class TeamProject < Project
      expose :greatest_access, as: :greatest_access_level do |project, options|
        options[:team].team_project_relationships.find_by(project_id: project.id).greatest_access
      end
    end

    class Group < Grape::Entity
      expose :id, :name, :path, :owner_id
    end

    class GroupDetail < Group
      expose :projects, using: Entities::Project
    end

    class GroupMember < UserBasic
      expose :group_access, as: :access_level do |user, options|
        options[:group].users_groups.find_by(user_id: user.id).group_access
      end
    end

    class Team < Grape::Entity
      expose :id, :name, :path, :creator_id
    end

    class TeamDetail < Team
      expose :projects, using: Entities::Project
    end

    class TeamMember < UserBasic
      expose :team_access, as: :access_level do |user, options|
        options[:team].team_users_relationships.find_by(user_id: user.id).team_access
      end
    end

    class RepoObject < Grape::Entity
      expose :name, :commit
      expose :protected do |repo, options|
        if options[:project]
          options[:project].protected_branch? repo.name
        end
      end
    end

    class RepoCommit < Grape::Entity
      expose :id, :short_id, :title, :author_name, :author_email, :created_at
    end

    class RepoCommitDetail < RepoCommit
      expose :parent_ids, :committed_date, :authored_date
    end

    class ProjectSnippet < Grape::Entity
      expose :id, :title, :file_name
      expose :author, using: Entities::UserBasic
      expose :expires_at, :updated_at, :created_at
    end

    class ProjectEntity < Grape::Entity
      expose :id, :iid
      expose (:project_id) { |entity| entity.project.id }
    end

    class Milestone < ProjectEntity
      expose :title, :description, :due_date, :state, :updated_at, :created_at
    end

    class Issue < ProjectEntity
      expose :title, :description
      expose :label_list, as: :labels
      expose :milestone, using: Entities::Milestone
      expose :assignee, :author, using: Entities::UserBasic
      expose :state, :updated_at, :created_at
    end

    class MergeRequest < ProjectEntity
      expose :target_branch, :source_branch, :title, :state, :upvotes, :downvotes
      expose :author, :assignee, using: Entities::UserBasic
      expose :source_project_id, :target_project_id
    end

    class SSHKey < Grape::Entity
      expose :id, :title, :key, :created_at
    end

    class Note < Grape::Entity
      expose :id
      expose :note, as: :body
      expose :attachment_identifier, as: :attachment
      expose :author, using: Entities::UserBasic
      expose :created_at
    end

    class MRNote < Grape::Entity
      expose :note
      expose :author, using: Entities::UserBasic
    end

    class Event < Grape::Entity
      expose :title, :project_id, :action_name
      expose :target_id, :target_type, :author_id
      expose :data, :target_title
    end

    class Namespace < Grape::Entity
      expose :id, :path, :kind
    end

    class Subscription < Grape::Entity
      expose :id
    end
  end
end
