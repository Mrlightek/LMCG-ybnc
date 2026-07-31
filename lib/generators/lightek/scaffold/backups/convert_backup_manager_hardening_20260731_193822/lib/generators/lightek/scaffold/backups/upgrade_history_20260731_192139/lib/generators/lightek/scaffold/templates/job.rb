module <%= class_name.pluralize %>

  class PipelineJob < ApplicationJob


    queue_as :default



    def perform(action:, id:, actor:)


      record = <%= class_name %>.find_by(id: id)


      activity = ActivityLog.start!(
        actor: actor,
        record: record,
        action: action
      )


      begin


        result =
          case action.to_sym

          when :create

            <%= class_name.pluralize %>::CreateService.call(
              actor: actor,
              record: record
            )


          when :update

            <%= class_name.pluralize %>::UpdateService.call(
              actor: actor,
              record: record
            )


          when :destroy

            <%= class_name.pluralize %>::DestroyService.call(
              actor: actor,
              record: record
            )

          end



        ActivityLog.complete!(activity, result)


      rescue => error


        ActivityLog.fail!(
          activity,
          error
        )


        raise error


      end


    end


  end

end
