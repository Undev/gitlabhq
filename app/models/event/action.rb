class Event::Action
  class << self
    def available_actions
      [
        # General actions
        :all,
        :created,
        :updated,
        :commented,
        :deleted,
        :added,
        :removed,
        :joined,
        :left,
        :transfer,

        # Project specific
        :commented_merge_request,
        :commented_issue,
        :commented_commit,
        :imported,

        # Git specific
        :pushed,
        :created_branch,
        :deleted_branch,
        :created_tag,
        :deleted_tag,
        :protected,
        :unprotected,
        :cloned,
        :blocked,
        :activate,

        # Issuable
        :opened,
        :closed,
        :reopened,
        :merged,
        :assigned,
        :reassigned,
        :resigned,

        # mass actions
        :members_added
      ]
    end

    def action_exists?(action)
      action = action.to_sym if action.is_a? String
      available_actions.include? action
    end

    def push_actions
      [ :pushed,
        :created_branch,
        :deleted_branch,
        :created_tag,
        :deleted_tag ]
    end

    def push_action?(action)
      action = action.to_sym if action.is_a? String
      push_actions.include? action
    end
  end
end
