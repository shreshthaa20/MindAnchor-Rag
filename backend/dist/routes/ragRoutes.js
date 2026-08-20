"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const ragController_1 = require("../controllers/ragController");
const authMiddleware_1 = require("../middleware/authMiddleware");
const router = express_1.default.Router();
router.post("/knowledge", authMiddleware_1.authenticateToken, ragController_1.createKnowledgeDocument);
router.get("/knowledge", authMiddleware_1.authenticateToken, ragController_1.getKnowledgeDocuments);
router.get("/search", authMiddleware_1.authenticateToken, ragController_1.semanticSearch);
router.post("/answer", authMiddleware_1.authenticateToken, ragController_1.answerWithRetrieval);
router.post("/wellness-guide", authMiddleware_1.authenticateToken, ragController_1.createWellnessGuideRecommendation);
exports.default = router;
