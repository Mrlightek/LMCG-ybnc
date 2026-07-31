class Donation < ApplicationRecord
  belongs_to :user
  enum :method, { paypal: 0, bank: 1, check: 2, cashapp: 3 }


  after_create_commit :trigger_create_job
  after_update_commit :trigger_update_job
  after_destroy_commit :trigger_destroy_job


  private


  def trigger_create_job
    donationCreateJob.perform_later(id)
  end


  def trigger_update_job
    donationUpdateJob.perform_later(id)
  end


  def trigger_destroy_job
    donationDestroyJob.perform_later(id)
  end


end
