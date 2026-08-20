import express from "express";
import {
  getChatHistory,
  sendChatMessage,
} from "../controllers/chatController";
import { authenticateToken } from "../middleware/authMiddleware";

const router = express.Router();

router.get("/", authenticateToken, getChatHistory);
router.post("/", authenticateToken, sendChatMessage);

export default router;
