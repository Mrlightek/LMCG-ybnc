module <%= name.pluralize %>
  class CreateJob < ApplicationJob

    queue_as :default

    def perform(id)
      <%= name %>.find(id).then do |record|
        <%= name.pluralize %>::CreateService.call(record)
      end
    end

  end
end