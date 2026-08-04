class <%= class_name %> < ApplicationRecord


<% attributes.each do |attribute| %>


<% if attribute.type == :references %>

  belongs_to :<%= attribute.name %>

<% end %>


<% if attribute.type.to_s == "has_many" %>

  has_many :<%= attribute.name %>

<% end %>


<% if attribute.type.to_s == "has_one" %>

  has_one :<%= attribute.name %>

<% end %>


<% end %>





  before_validation :generate_slug,
    if: -> {
      respond_to?(:slug) &&
      slug.blank?
    }





  after_create_commit :pipeline_create

  after_update_commit :pipeline_update

  after_destroy_commit :pipeline_destroy





<% attributes.each do |attribute| %>


<% if [:string, :text].include?(attribute.type.to_sym) %>

  validates :<%= attribute.name %>,
    presence: true

<% end %>


<% end %>





  scope :recent,
    -> {
      order(
        created_at: :desc
      )
    }





  private





  def generate_slug

    self.slug =
      title.parameterize

  rescue NoMethodError

    nil

  end





  def pipeline_create

    <%= class_name %>PipelineJob.perform_later(

      action: :create,

      id: id,

      actor: Current.actor

    )

  end





  def pipeline_update

    <%= class_name %>PipelineJob.perform_later(

      action: :update,

      id: id,

      actor: Current.actor

    )

  end





  def pipeline_destroy

    <%= class_name %>PipelineJob.perform_later(

      action: :destroy,

      id: id,

      actor: Current.actor

    )

  end





end
