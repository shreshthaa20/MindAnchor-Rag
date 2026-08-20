import { Response } from "express";
import { AuthRequest } from "../middleware/authMiddleware";
import {
  createChatResponseForUser,
  getChatHistoryForUser,
} from "../services/chatService";
import { sendControllerError } from "../utils/controllerError";

export const getChatHistory = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const messages = await getChatHistoryForUser(
      req.user?.id,
      req.query.type
    );

    return res.status(200).json({
      success: true,
      messages,
    });
  } catch (error) {
    return sendControllerError(
      res,
      error,
      "Failed to fetch chat history"
    );
  }
};

export const sendChatMessage = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const result = await createChatResponseForUser(
      req.user?.id,
      req.body.message,
      req.body.type
    );

    return res.status(201).json({
      success: true,
      userMessage: result.userMessage,
      assistantMessage: result.assistantMessage,
    });
  } catch (error) {
    return sendControllerError(
      res,
      error,
      "Failed to generate chat response"
    );
  }
};
