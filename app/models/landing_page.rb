class LandingPage < ApplicationRecord


  after_create_commit :trigger_create_job
  after_update_commit :trigger_update_job
  after_destroy_commit :trigger_destroy_job


  private


  def trigger_create_job
    landing_pageCreateJob.perform_later(id)
  end


  def trigger_update_job
    landing_pageUpdateJob.perform_later(id)
  end


  def trigger_destroy_job
    landing_pageDestroyJob.perform_later(id)
  end


end
