# UserTeamManager class
#
# Used for manage User teams with project repositories
module Gitlab
  class UserTeamManager
    class << self
      def assign(team, project, access)
        project = Project.find(project) unless project.is_a? Project
        searched_project = team.user_team_project_relationships.find_by_project_id(project.id)

        unless searched_project.present?
          team.user_team_project_relationships.create(project_id: project.id, greatest_access: access)
          update_team_users_access_in_project(team, project, :added)
        end

        # TODO
        # resend delayed notifications Team-Project
      end

      def resign(team, project)
        project = Project.find(project) unless project.is_a? Project

        team.user_team_project_relationships.with_project(project).destroy_all

        update_team_users_access_in_project(team, project, :deleted)
        # TODO
        # resend delayed notifications Team-Project
      end

      def update_team_user_membership(team, member, options)
        updates = {}

        if options[:default_projects_access].present?
          default_projects_access = options[:default_projects_access].to_s

          if default_projects_access != team.default_projects_access(member).to_s
            updates[:permission] = default_projects_access
          end
        end

        if options[:group_admin].present?
          group_admin = options[:group_admin].to_s == "1" ? true : false

          if group_admin != team.admin?(member)
            updates[:group_admin] = group_admin
          end
        end

        return true if updates.blank?

        user_team_relationship = team.user_team_user_relationships.find_by_user_id(member)
        return false unless user_team_relationship.update_attributes(updates)

        rebuild_project_permissions_to_member(team, member) if updates[:permission]

        true
      end

      def update_project_greates_access(team, project, permission)
        project_relation = team.user_team_project_relationships.find_by_project_id(project)
        if permission != team.max_project_access(project)
          if project_relation.update_attributes(greatest_access: permission)
            update_team_users_access_in_project(team, project, :updated)
            true
          else
            false
          end
        else
          true
        end
      end

      def rebuild_project_permissions_to_member(team, member)
        team.projects.each do |project|
          update_team_user_access_in_project(team, member, project, :updated)
        end
      end

      def update_team_users_access_in_project(team, project, action)
        members = team.members
        members.each do |member|
          update_team_user_access_in_project(team, member, project, action)
        end
      end

      def update_team_user_access_in_project(team, user, project, action)
        granted_access = max_teams_member_permission_in_project(user, project, action)
        project_team_user = UsersProject.find_by_user_id_and_project_id(user.id, project.id)

        if granted_access.zero?
          project_team_user.destroy if project_team_user.present?
          return
        end

        if project_team_user.present?
          project_team_user.update_attributes(project_access: granted_access)
        else
          project.team << [user, granted_access]
        end
      end

      def max_teams_member_permission_in_project(user, project, action = nil, teams = nil)
        result_access = 0

        teams ||= project.user_teams.with_member(user)

        if action && (action == :added)
          result_access = project.users_projects.with_user(user).first.project_access if project.users_projects.with_user(user).any?
        end

        if teams.any?
          teams.each do |team|
            granted_access = max_team_member_permission_in_project(team, user, project)
            result_access = [granted_access, result_access].max
          end
        end
        result_access
      end

      def max_team_member_permission_in_project(team, user, project)
        member_access = team.default_projects_access(user)
        team_access = team.user_team_project_relationships.find_by_project_id(project.id).greatest_access

        [team_access, member_access].min
      end

      def add_member_into_team(team, user, access, admin)
        user = User.find(user) unless user.is_a? User

        team.user_team_user_relationships.create(user_id: user.id, permission: access, group_admin: admin)
        team.projects.each do |project|
          update_team_user_access_in_project(team, user, project, :added)
        end
      end

      def remove_member_from_team(team, user)
        user = User.find(user) unless user.is_a? User

        team.user_team_user_relationships.with_user(user).destroy_all
        other_teams = []
        team.projects.each do |project|
          other_teams << project.user_teams.with_member(user)
        end
        other_teams.uniq
        unless other_teams.any?
          UsersProject.in_projects(team.projects).with_user(user).destroy_all
        end
      end

      def assign_to_group(team, group, access)
        group = find_entity(group, Group)
        team = find_entity(team, UserTeam)

        searched_group = team.user_team_group_relationships.find_by_group_id(group.id)

        unless searched_group.present?
          team.user_team_group_relationships.create(group_id: group.id, greatest_access: access)
          group.projects.each do |project|
            assign(team, project, access)
          end
        end
      end

      def resign_from_group(team, group)
        group = find_entity(group, Group)
        team = find_entity(team, UserTeam)

        team.user_team_group_relationships.with_group(group).destroy_all

        group.projects.each do |project|
          resign(team, project)
        end
      end

      def update_team_user_access_in_group(team, group, access, rebuild_flag = nil)
        group = find_entity(group, Group)
        team = find_entity(team, UserTeam)

        relationship = team.user_team_group_relationships.with_group(group)
        relationship.each do |rel|
          rel.update_attributes(greatest_access: access)
        end

        if rebuild_flag
          group.projects.each do |project|
            update_project_greates_access(team, project, permission)
          end
        end
      end

      def find_entity(entity, entity_type)
        entity.is_a?(entity_type) ? entity : entity_type.find(entity)
      end

    end
  end
end