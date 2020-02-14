class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true #=> foreign(外部キー)としてuse_idを使う

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at] #=> created_at(作成日)でツイート新しい順に使う、複合キーindex（よくあるクエリを高速化）
  end
end
