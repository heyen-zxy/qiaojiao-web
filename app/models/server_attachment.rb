class ServerAttachment < Attachment
  has_and_belongs_to_many :orders, association_foreign_key: :model_id, join_table: 'model_attachments'
end
