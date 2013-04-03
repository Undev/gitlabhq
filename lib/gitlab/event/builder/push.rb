class Gitlab::Event::Builder::Push < Gitlab::Event::Builder::Base
  class << self
    def can_build?(action, data)
      known_action = known_action? action, [:pushed]
      known_source = data.is_a? ::Hash
      known_source && known_action
    end

    def build(action, source, user, data)
      meta = parse_action(action)
      actions = []

      target = ::Project.find(data[:project_id])
      push_data = data[:push_data]
      user = ::User.find(push_data[:user_id])

      case meta[:action]
      when :pushed
        actions << :created_branch  if push_data[:ref] =~ /^refs\/heads/ && push_data[:before] =~ /^00000/
        actions << :deleted_branch  if push_data[:ref] =~ /^refs\/heads/ && push_data[:after]  =~ /^00000/
        actions << :created_tag     if push_data[:ref] =~ /^refs\/tag/   && push_data[:before] =~ /^00000/
        actions << :deleted_tag     if push_data[:ref] =~ /^refs\/tag/   && push_data[:after]  =~ /^00000/

        actions << :pushed          if actions.blank?
      end

      events = []

      actions.each do |act|
        events << ::Event.new(action: act, source_type: source, data: push_data.to_json, author: user, target: target)
      end

      events

    end
  end
end