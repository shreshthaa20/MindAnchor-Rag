"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteJournalForUser = exports.updateJournalForUser = exports.getJournalForUser = exports.getJournalsForUser = exports.createJournalForUser = void 0;
const database_1 = require("../config/database");
const AppError_1 = require("../utils/AppError");
const normalizeTitle = (title) => {
    if (typeof title !== "string" || title.trim().length === 0) {
        throw new AppError_1.AppError("Title is required.", 400);
    }
    if (title.trim().length > 120) {
        throw new AppError_1.AppError("Title must be 120 characters or fewer.", 400);
    }
    return title.trim();
};
const normalizeContent = (content) => {
    if (typeof content !== "string" || content.trim().length === 0) {
        throw new AppError_1.AppError("Content is required.", 400);
    }
    if (content.trim().length > 10000) {
        throw new AppError_1.AppError("Content must be 10000 characters or fewer.", 400);
    }
    return content.trim();
};
const createJournalForUser = async (userId, title, content) => {
    if (!userId) {
        throw new AppError_1.AppError("Unauthorized.", 401);
    }
    const normalizedTitle = normalizeTitle(title);
    const normalizedContent = normalizeContent(content);
    const result = await database_1.pool.query(`
    INSERT INTO journals (user_id, title, content)
    VALUES ($1, $2, $3)
    RETURNING *
    `, [userId, normalizedTitle, normalizedContent]);
    return result.rows[0];
};
exports.createJournalForUser = createJournalForUser;
const getJournalsForUser = async (userId) => {
    if (!userId) {
        throw new AppError_1.AppError("Unauthorized.", 401);
    }
    const result = await database_1.pool.query(`
    SELECT *
    FROM journals
    WHERE user_id = $1
    ORDER BY created_at DESC
    `, [userId]);
    return result.rows;
};
exports.getJournalsForUser = getJournalsForUser;
const getJournalForUser = async (userId, journalId) => {
    if (!userId) {
        throw new AppError_1.AppError("Unauthorized.", 401);
    }
    if (!Number.isInteger(journalId) || journalId <= 0) {
        throw new AppError_1.AppError("Invalid journal id.", 400);
    }
    const result = await database_1.pool.query(`
    SELECT *
    FROM journals
    WHERE id = $1 AND user_id = $2
    `, [journalId, userId]);
    if (result.rows.length === 0) {
        throw new AppError_1.AppError("Journal not found.", 404);
    }
    return result.rows[0];
};
exports.getJournalForUser = getJournalForUser;
const updateJournalForUser = async (userId, journalId, title, content) => {
    if (!userId) {
        throw new AppError_1.AppError("Unauthorized.", 401);
    }
    if (!Number.isInteger(journalId) || journalId <= 0) {
        throw new AppError_1.AppError("Invalid journal id.", 400);
    }
    const normalizedTitle = normalizeTitle(title);
    const normalizedContent = normalizeContent(content);
    const result = await database_1.pool.query(`
    UPDATE journals
    SET title = $1,
        content = $2,
        updated_at = NOW()
    WHERE id = $3 AND user_id = $4
    RETURNING *
    `, [normalizedTitle, normalizedContent, journalId, userId]);
    if (result.rows.length === 0) {
        throw new AppError_1.AppError("Journal not found.", 404);
    }
    return result.rows[0];
};
exports.updateJournalForUser = updateJournalForUser;
const deleteJournalForUser = async (userId, journalId) => {
    if (!userId) {
        throw new AppError_1.AppError("Unauthorized.", 401);
    }
    if (!Number.isInteger(journalId) || journalId <= 0) {
        throw new AppError_1.AppError("Invalid journal id.", 400);
    }
    const result = await database_1.pool.query(`
    DELETE FROM journals
    WHERE id = $1 AND user_id = $2
    `, [journalId, userId]);
    if (result.rowCount === 0) {
        throw new AppError_1.AppError("Journal not found.", 404);
    }
};
exports.deleteJournalForUser = deleteJournalForUser;
