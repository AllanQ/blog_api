class ChangeRatingIndexOnPosts < ActiveRecord::Migration[5.1]
  def change
    remove_index :posts, :rating

    reversible do |direction|
      direction.up do
        execute 'CREATE INDEX index_posts_on_rating_desc_nulls_last ON posts (rating DESC NULLS LAST);'
      end
      direction.down do
        execute 'DROP INDEX index_posts_on_rating_desc_nulls_last;'
      end
    end
  end
end
