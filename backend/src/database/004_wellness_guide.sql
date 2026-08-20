ALTER TABLE chat_messages
DROP CONSTRAINT IF EXISTS chat_messages_chat_type_check;

ALTER TABLE chat_messages
ADD CONSTRAINT chat_messages_chat_type_check
CHECK (chat_type IN ('wellness_guide'));

ALTER TABLE knowledge_base
ALTER COLUMN user_id DROP NOT NULL;

ALTER TABLE knowledge_base
ADD COLUMN IF NOT EXISTS category VARCHAR(80) NOT NULL DEFAULT 'General Wellness',
ADD COLUMN IF NOT EXISTS tags TEXT[] NOT NULL DEFAULT '{}',
ADD COLUMN IF NOT EXISTS is_curated BOOLEAN NOT NULL DEFAULT false;

CREATE INDEX IF NOT EXISTS idx_knowledge_base_curated_category
ON knowledge_base (is_curated, category);
