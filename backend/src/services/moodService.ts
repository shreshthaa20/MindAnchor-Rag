import { pool } from "../config/database";
import { AppError } from "../utils/AppError";

export interface Mood {
  id: number;
  user_id: number;
  mood: string;
  created_at: Date;
  updated_at?: Date;
}

const normalizeMood = (mood: unknown): string => {
  if (typeof mood !== "string" || mood.trim().length === 0) {
    throw new AppError("Mood is required.", 400);
  }

  if (mood.trim().length > 80) {
    throw new AppError("Mood must be 80 characters or fewer.", 400);
  }

  return mood.trim();
};

export const createMoodForUser = async (
  userId: number | undefined,
  mood: unknown
): Promise<Mood> => {
  if (!userId) {
    throw new AppError("Unauthorized.", 401);
  }

  const normalizedMood = normalizeMood(mood);

  const result = await pool.query<Mood>(
    `
    INSERT INTO moods (user_id, mood)
    VALUES ($1, $2)
    RETURNING *
    `,
    [userId, normalizedMood]
  );

  return result.rows[0];
};

export const getMoodsForUser = async (
  userId: number | undefined
): Promise<Mood[]> => {
  if (!userId) {
    throw new AppError("Unauthorized.", 401);
  }

  const result = await pool.query<Mood>(
    `
    SELECT *
    FROM moods
    WHERE user_id = $1
    ORDER BY created_at DESC
    `,
    [userId]
  );

  return result.rows;
};

export const updateMoodForUser = async (
  userId: number | undefined,
  moodId: number,
  mood: unknown
): Promise<Mood> => {
  if (!userId) {
    throw new AppError("Unauthorized.", 401);
  }

  if (!Number.isInteger(moodId) || moodId <= 0) {
    throw new AppError("Invalid mood id.", 400);
  }

  const normalizedMood = normalizeMood(mood);

  const result = await pool.query<Mood>(
    `
    UPDATE moods
    SET mood = $1,
        updated_at = NOW()
    WHERE id = $2 AND user_id = $3
    RETURNING *
    `,
    [normalizedMood, moodId, userId]
  );

  if (result.rows.length === 0) {
    throw new AppError("Mood not found.", 404);
  }

  return result.rows[0];
};

export const deleteMoodForUser = async (
  userId: number | undefined,
  moodId: number
): Promise<void> => {
  if (!userId) {
    throw new AppError("Unauthorized.", 401);
  }

  if (!Number.isInteger(moodId) || moodId <= 0) {
    throw new AppError("Invalid mood id.", 400);
  }

  const result = await pool.query(
    `
    DELETE FROM moods
    WHERE id = $1 AND user_id = $2
    `,
    [moodId, userId]
  );

  if (result.rowCount === 0) {
    throw new AppError("Mood not found.", 404);
  }
};
