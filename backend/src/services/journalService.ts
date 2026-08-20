import { pool } from "../config/database";
import { AppError } from "../utils/AppError";

export interface Journal {
  id: number;
  user_id: number;
  title: string;
  content: string;
  created_at: Date;
  updated_at: Date;
}

const normalizeTitle = (title: unknown): string => {
  if (typeof title !== "string" || title.trim().length === 0) {
    throw new AppError("Title is required.", 400);
  }

  if (title.trim().length > 120) {
    throw new AppError("Title must be 120 characters or fewer.", 400);
  }

  return title.trim();
};

const normalizeContent = (content: unknown): string => {
  if (typeof content !== "string" || content.trim().length === 0) {
    throw new AppError("Content is required.", 400);
  }

  if (content.trim().length > 10000) {
    throw new AppError("Content must be 10000 characters or fewer.", 400);
  }

  return content.trim();
};

export const createJournalForUser = async (
  userId: number | undefined,
  title: unknown,
  content: unknown
): Promise<Journal> => {
  if (!userId) {
    throw new AppError("Unauthorized.", 401);
  }

  const normalizedTitle = normalizeTitle(title);
  const normalizedContent = normalizeContent(content);

  const result = await pool.query<Journal>(
    `
    INSERT INTO journals (user_id, title, content)
    VALUES ($1, $2, $3)
    RETURNING *
    `,
    [userId, normalizedTitle, normalizedContent]
  );

  return result.rows[0];
};

export const getJournalsForUser = async (
  userId: number | undefined
): Promise<Journal[]> => {
  if (!userId) {
    throw new AppError("Unauthorized.", 401);
  }

  const result = await pool.query<Journal>(
    `
    SELECT *
    FROM journals
    WHERE user_id = $1
    ORDER BY created_at DESC
    `,
    [userId]
  );

  return result.rows;
};

export const getJournalForUser = async (
  userId: number | undefined,
  journalId: number
): Promise<Journal> => {
  if (!userId) {
    throw new AppError("Unauthorized.", 401);
  }

  if (!Number.isInteger(journalId) || journalId <= 0) {
    throw new AppError("Invalid journal id.", 400);
  }

  const result = await pool.query<Journal>(
    `
    SELECT *
    FROM journals
    WHERE id = $1 AND user_id = $2
    `,
    [journalId, userId]
  );

  if (result.rows.length === 0) {
    throw new AppError("Journal not found.", 404);
  }

  return result.rows[0];
};

export const updateJournalForUser = async (
  userId: number | undefined,
  journalId: number,
  title: unknown,
  content: unknown
): Promise<Journal> => {
  if (!userId) {
    throw new AppError("Unauthorized.", 401);
  }

  if (!Number.isInteger(journalId) || journalId <= 0) {
    throw new AppError("Invalid journal id.", 400);
  }

  const normalizedTitle = normalizeTitle(title);
  const normalizedContent = normalizeContent(content);

  const result = await pool.query<Journal>(
    `
    UPDATE journals
    SET title = $1,
        content = $2,
        updated_at = NOW()
    WHERE id = $3 AND user_id = $4
    RETURNING *
    `,
    [normalizedTitle, normalizedContent, journalId, userId]
  );

  if (result.rows.length === 0) {
    throw new AppError("Journal not found.", 404);
  }

  return result.rows[0];
};

export const deleteJournalForUser = async (
  userId: number | undefined,
  journalId: number
): Promise<void> => {
  if (!userId) {
    throw new AppError("Unauthorized.", 401);
  }

  if (!Number.isInteger(journalId) || journalId <= 0) {
    throw new AppError("Invalid journal id.", 400);
  }

  const result = await pool.query(
    `
    DELETE FROM journals
    WHERE id = $1 AND user_id = $2
    `,
    [journalId, userId]
  );

  if (result.rowCount === 0) {
    throw new AppError("Journal not found.", 404);
  }
};
