"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendChatMessage = exports.getChatHistory = void 0;
const chatService_1 = require("../services/chatService");
const controllerError_1 = require("../utils/controllerError");
const getChatHistory = async (req, res) => {
    try {
        const messages = await (0, chatService_1.getChatHistoryForUser)(req.user?.id, req.query.type);
        return res.status(200).json({
            success: true,
            messages,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to fetch chat history");
    }
};
exports.getChatHistory = getChatHistory;
const sendChatMessage = async (req, res) => {
    try {
        const result = await (0, chatService_1.createChatResponseForUser)(req.user?.id, req.body.message, req.body.type);
        return res.status(201).json({
            success: true,
            userMessage: result.userMessage,
            assistantMessage: result.assistantMessage,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to generate chat response");
    }
};
exports.sendChatMessage = sendChatMessage;
