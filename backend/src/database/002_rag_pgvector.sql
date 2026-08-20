CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS knowledge_base (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  category VARCHAR(80) NOT NULL DEFAULT 'General Wellness',
  title VARCHAR(160) NOT NULL,
  content TEXT NOT NULL,
  source TEXT,
  tags TEXT[] NOT NULL DEFAULT '{}',
  is_curated BOOLEAN NOT NULL DEFAULT false,
  embedding vector(768) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_knowledge_base_user_created_at
ON knowledge_base (user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_knowledge_base_curated_category
ON knowledge_base (is_curated, category);

CREATE INDEX IF NOT EXISTS idx_knowledge_base_embedding
ON knowledge_base USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);
