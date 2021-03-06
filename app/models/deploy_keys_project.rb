# == Schema Information
#
# Table name: deploy_keys_projects
#
#  id            :integer          not null, primary key
#  deploy_key_id :integer          not null
#  project_id    :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

class DeployKeysProject < ActiveRecord::Base
  attr_accessible :key_id, :project_id

  belongs_to :project
  belongs_to :deploy_key

  validates :deploy_key, presence: true
  validates :deploy_key_id, uniqueness: { scope: [:project_id], message: "already exists in project" }

  validates :project, presence: true
end
