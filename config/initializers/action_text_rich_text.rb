module RichTextFullTextSearch
  extend ActiveSupport::Concern

  included do
    before_save { assign_attributes plain_text_body: body.to_plain_text }

    scope :with_body_containing, ->(query) { where <<~SQL, query: query }
      to_tsvector('english', plain_text_body) @@ websearch_to_tsquery(:query)
    SQL
  end
end

ActiveSupport.on_load :action_text_rich_text do
  include RichTextFullTextSearch
end
