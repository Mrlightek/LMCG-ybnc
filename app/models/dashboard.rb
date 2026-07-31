class Dashboard < ApplicationRecord


  after_create_commit :trigger_create_job
  after_update_commit :trigger_update_job
  after_destroy_commit :trigger_destroy_job


  private


  def trigger_create_job
    dashboardCreateJob.perform_later(id)
  end


  def trigger_update_job
    dashboardUpdateJob.perform_later(id)
  end


  def trigger_destroy_job
    dashboardDestroyJob.perform_later(id)
  end


end
