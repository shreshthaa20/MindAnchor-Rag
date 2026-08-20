CREATE TABLE IF NOT EXISTS safety_events (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
  event_type VARCHAR(40) NOT NULL,
  risk_level VARCHAR(20) NOT NULL,
  source VARCHAR(40) NOT NULL,
  message_preview TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_safety_events_user_created_at
ON safety_events (user_id, created_at DESC);
