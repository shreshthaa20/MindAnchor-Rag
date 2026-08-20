UPDATE chat_messages
SET chat_type = 'wellness_guide'
WHERE chat_type IN ('coach', 'companion');

ALTER TABLE chat_messages
DROP CONSTRAINT IF EXISTS chat_messages_chat_type_check;

ALTER TABLE chat_messages
ADD CONSTRAINT chat_messages_chat_type_check
CHECK (chat_type IN ('wellness_guide'));
