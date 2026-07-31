class PopulateMissingContentSlugs < ActiveRecord::Migration[8.0]

  def up

    Article.where(slug: nil).find_each do |article|
      article.update_columns(
        slug: article.title.to_s.parameterize
      )
    end


    ResourceItem.where(slug: nil).find_each do |resource|
      resource.update_columns(
        slug: resource.title.to_s.parameterize
      )
    end

  end


  def down

    Article.update_all(slug: nil)
    ResourceItem.update_all(slug: nil)

  end

end
