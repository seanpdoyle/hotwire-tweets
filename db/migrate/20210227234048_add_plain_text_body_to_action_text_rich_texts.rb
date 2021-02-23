class AddPlainTextBodyToActionTextRichTexts < ActiveRecord::Migration[7.0]
  def change
    change_table :action_text_rich_texts do |t|
      t.text :plain_text_body

      t.index "to_tsvector('english', plain_text_body)", using: :gin, name: "tsvector_body_idx"
    end
  end
end
