class ResourceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :attributes,
           type: :array,
           default: [],
           banner: "field:type field:type"

  def create_model
    generate "model", "#{name} #{attributes.join(' ')}"
  end

  def create_controller
    generate "controller", name.pluralize
  end

  def create_service
    template(
      "service.rb",
      "app/services/#{name.underscore.pluralize}/create_service.rb"
    )
  end

  def create_job
    template(
      "job.rb",
      "app/jobs/#{name.underscore.pluralize}/create_job.rb"
    )
  end
end