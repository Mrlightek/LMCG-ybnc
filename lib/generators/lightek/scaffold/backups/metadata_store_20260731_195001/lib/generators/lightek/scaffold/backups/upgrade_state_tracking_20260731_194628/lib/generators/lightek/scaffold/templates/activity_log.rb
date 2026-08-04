class ActivityLog < ApplicationRecord


  belongs_to :actor,
    polymorphic: true


  belongs_to :record,
    polymorphic: true



  validates :action,
    presence: true



  validates :status,
    presence: true




  def self.start!(actor:, record:, action:)


    create!(
      actor: actor,
      record: record,
      action: action,
      status: "started"
    )


  end





  def self.complete!(activity, result)


    activity.update!(
      status: "completed",
      message: result.class.name
    )


  end





  def self.fail!(activity, error)


    activity.update!(
      status: "failed",
      message: error.message
    )


  end



end
