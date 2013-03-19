# == Schema Information
#
# Table name: services
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  title       :string(255)
#  token       :string(255)
#  project_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  active      :boolean          default(FALSE), not null
#  project_url :string(255)
#

class Service < ActiveRecord::Base
  include Watchable

  attr_accessible :title, :token, :type, :active

  belongs_to :project
  has_one :service_hook

  has_many :events,         as: :source
  has_many :subscriptions,  as: :target, class_name: Event::Subscription
  has_many :notifications,  through: :subscriptions
  has_many :subscribers,    through: :subscriptions

  validates :project_id, presence: true

  actions_to_watch [:created, :updated, :deleted]
  actions_sources [watchable_name]

  def activated?
    active
  end
end
