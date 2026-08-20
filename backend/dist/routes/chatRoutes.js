"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const chatController_1 = require("../controllers/chatController");
const authMiddleware_1 = require("../middleware/authMiddleware");
const router = express_1.default.Router();
router.get("/", authMiddleware_1.authenticateToken, chatController_1.getChatHistory);
router.post("/", authMiddleware_1.authenticateToken, chatController_1.sendChatMessage);
exports.default = router;
