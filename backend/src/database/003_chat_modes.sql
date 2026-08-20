ALTER TABLE chat_messages
ADD COLUMN IF NOT EXISTS chat_type VARCHAR(20) NOT NULL DEFAULT 'wellness_guide'
CHECK (chat_type IN ('wellness_guide'));

CREATE INDEX IF NOT EXISTS idx_chat_messages_user_type_created_at
ON chat_messages (user_id, chat_type, created_at ASC);
