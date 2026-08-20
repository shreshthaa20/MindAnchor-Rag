"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createChatResponseForUser = exports.getChatHistoryForUser = void 0;
const database_1 = require("../config/database");
const AppError_1 = require("../utils/AppError");
const safetyService_1 = require("./safetyService");
const normalizeChatType = (chatType) => {
    if (chatType === "wellness_guide") {
        return "wellness_guide";
    }
    if (chatType === undefined || chatType === null || chatType === "companion") {
        return "companion";
    }
    throw new AppError_1.AppError("Invalid chat type.", 400);
};
const normalizeMessage = (message) => {
    if (typeof message !== "string" || message.trim().length === 0) {
        throw new AppError_1.AppError("Message is required.", 400);
    }
    if (message.trim().length > 4000) {
        throw new AppError_1.AppError("Message must be 4000 characters or fewer.", 400);
    }
    return message.trim();
};
const getChatHistoryForUser = async (userId, chatType) => {
    if (!userId) {
        throw new AppError_1.AppError("Unauthorized.", 401);
    }
    const normalizedChatType = normalizeChatType(chatType);
    const result = await database_1.pool.query(`
    SELECT *
    FROM chat_messages
    WHERE user_id = $1 AND chat_type = $2
    ORDER BY created_at ASC
    `, [userId, normalizedChatType]);
    return result.rows;
};
exports.getChatHistoryForUser = getChatHistoryForUser;
const createChatResponseForUser = async (userId, message, chatType) => {
    if (!userId) {
        throw new AppError_1.AppError("Unauthorized.", 401);
    }
    const normalizedMessage = normalizeMessage(message);
    const normalizedChatType = normalizeChatType(chatType);
    const client = await database_1.pool.connect();
    try {
        await client.query("BEGIN");
        const userMessageResult = await client.query(`
      INSERT INTO chat_messages (user_id, role, chat_type, content)
      VALUES ($1, 'user', $2, $3)
      RETURNING *
      `, [userId, normalizedChatType, normalizedMessage]);
        const safetyAssessment = (0, safetyService_1.assessSafetyRisk)(normalizedMessage);
        if (safetyAssessment.hasCrisisRisk && safetyAssessment.response) {
            await (0, safetyService_1.logSafetyEvent)({
                userId,
                eventType: "chat_crisis_signal",
                riskLevel: safetyAssessment.riskLevel,
                source: normalizedChatType,
                message: normalizedMessage,
            });
            const assistantMessageResult = await client.query(`
        INSERT INTO chat_messages (user_id, role, chat_type, content)
        VALUES ($1, 'assistant', $2, $3)
        RETURNING *
        `, [userId, normalizedChatType, safetyAssessment.response]);
            await client.query("COMMIT");
            return {
                userMessage: userMessageResult.rows[0],
                assistantMessage: assistantMessageResult.rows[0],
            };
        }
        const historyResult = await client.query(`
      SELECT *
      FROM chat_messages
      WHERE user_id = $1 AND chat_type = $2
      ORDER BY created_at DESC
      LIMIT 12
      `, [userId, normalizedChatType]);
        const history = historyResult.rows.reverse().map((item) => ({
            role: item.role,
            content: item.content,
        }));
        let assistantText = "";
        try {
            const url = `${process.env.RAG_SERVICE_URL || "http://localhost:8000"}/chat`;
            const response = await fetch(url, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    user_id: userId,
                    chat_type: normalizedChatType,
                    messages: history,
                }),
            });
            if (!response.ok) {
                const errData = await response.json().catch(() => ({}));
                throw new AppError_1.AppError(errData.detail || "Failed to generate chat response from RAG service.", response.status);
            }
            const data = await response.json();
            assistantText = data.answer;
        }
        catch (error) {
            console.error("DEBUG Node.js COMPANION ERROR:", error);
            const fallbackText = "I'm here with you. I can't reach the AI service right now, but you can still take one small grounding step: pause, take a slow breath, and name one thing you need in this moment. If this is urgent or you may not be safe, please contact local emergency services or a trusted person immediately.";
            await (0, safetyService_1.logSafetyEvent)({
                userId,
                eventType: "chat_ai_fallback",
                riskLevel: "none",
                source: normalizedChatType,
                message: normalizedMessage,
            });
            const assistantMessageResult = await client.query(`
        INSERT INTO chat_messages (user_id, role, chat_type, content)
        VALUES ($1, 'assistant', $2, $3)
        RETURNING *
        `, [userId, normalizedChatType, fallbackText]);
            await client.query("COMMIT");
            return {
                userMessage: userMessageResult.rows[0],
                assistantMessage: assistantMessageResult.rows[0],
            };
        }
        if (!assistantText) {
            throw new AppError_1.AppError("AI response was empty.", 502);
        }
        const assistantMessageResult = await client.query(`
      INSERT INTO chat_messages (user_id, role, chat_type, content)
      VALUES ($1, 'assistant', $2, $3)
      RETURNING *
      `, [userId, normalizedChatType, assistantText]);
        await client.query("COMMIT");
        return {
            userMessage: userMessageResult.rows[0],
            assistantMessage: assistantMessageResult.rows[0],
        };
    }
    catch (error) {
        await client.query("ROLLBACK");
        throw error;
    }
    finally {
        client.release();
    }
};
exports.createChatResponseForUser = createChatResponseForUser;
