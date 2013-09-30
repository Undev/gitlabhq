module Projects
  class CreateContext < ::BaseContext
    def execute
      # get namespace id
      namespace_id = params.delete(:namespace_id)

      # Load default feature settings
      default_features = Gitlab.config.gitlab.default_projects_features

      default_opts = {
        issues_enabled:         default_features.issues,
        wiki_enabled:           default_features.wiki,
        wall_enabled:           default_features.wall,
        snippets_enabled:       default_features.snippets,
        merge_requests_enabled: default_features.merge_requests,
        public:                 default_features.public
      }.stringify_keys

      @project = Project.new(default_opts.merge(params))
      @project.issues_tracker = "redmine"
      @project.git_protocol_enabled = false

      # Parametrize path for project
      #
      # Ex.
      #  'GitLab HQ'.parameterize => "gitlab-hq"
      #
      @project.path = @project.name.dup.parameterize unless @project.path.present?


      if namespace_id
        # Find matching namespace and check if it allowed
        # for current user if namespace_id passed.
        if allowed_namespace?(current_user, namespace_id)
          @project.namespace_id = namespace_id
        else
          deny_namespace
          return @project
        end
      else
        # Set current user namespace if namespace_id is nil
        @project.namespace_id = current_user.namespace_id
      end

      @project.creator = current_user

      if @project.save
        @project.discover_default_branch

        master_permission = @project.users_projects.find_by_user_id(current_user)

        if master_permission.blank?
          @project.users_projects.create(project_access: UsersProject::OWNER, user: current_user)
        else
          master_permission.update_attribute(:project_access, UsersProject::OWNER) if master_permission.project_access != UsersProject::OWNER
        end

        if current_user.notification_setting && current_user.notification_setting.subscribe_if_owner
          SubscriptionService.subscribe(current_user, :all, @project, :all)
        end

      end

      receive_delayed_notifications

      @project
    rescue => ex
      @project.errors.add(:base, ex.message)
      @project.errors.add(:base, "Can't save project. Please try again later")
      @project
    end

    protected

    def deny_namespace
      @project.errors.add(:namespace, "is not valid")
    end

    def allowed_namespace?(user, namespace_id)
      namespace = Namespace.find_by_id(namespace_id)
      current_user.can?(:manage_namespace, namespace)
    end
  end
end
