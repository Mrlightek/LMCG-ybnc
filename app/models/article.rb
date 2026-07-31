class Article < ApplicationRecord


  after_create_commit :trigger_create_job
  after_update_commit :trigger_update_job
  after_destroy_commit :trigger_destroy_job


  def to_param
    slug
  end

  private


  def trigger_create_job
    articleCreateJob.perform_later(id)
  end


  def trigger_update_job
    articleUpdateJob.perform_later(id)
  end


  def trigger_destroy_job
    articleDestroyJob.perform_later(id)
  end
  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug ||= title.to_s.parameterize
  end

end
