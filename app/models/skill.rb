class Skill < ApplicationRecord
  belongs_to :user


  after_create_commit :trigger_create_job
  after_update_commit :trigger_update_job
  after_destroy_commit :trigger_destroy_job


  private


  def trigger_create_job
    skillCreateJob.perform_later(id)
  end


  def trigger_update_job
    skillUpdateJob.perform_later(id)
  end


  def trigger_destroy_job
    skillDestroyJob.perform_later(id)
  end


end
