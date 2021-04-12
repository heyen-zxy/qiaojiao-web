class MessageAttachment < Attachment
  has_and_belongs_to_many :public_messages, association_foreign_key: :model_id, join_table: 'model_attachments'
end
