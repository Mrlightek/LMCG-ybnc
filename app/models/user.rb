class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :skills
  enum :role, { member: 0, admin: 1 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }


  after_create_commit :trigger_create_job
  after_update_commit :trigger_update_job
  after_destroy_commit :trigger_destroy_job


  private


  def trigger_create_job
    userCreateJob.perform_later(id)
  end


  def trigger_update_job
    userUpdateJob.perform_later(id)
  end


  def trigger_destroy_job
    userDestroyJob.perform_later(id)
  end


end
