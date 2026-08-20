import express from "express";
import {
  answerWithRetrieval,
  createWellnessGuideRecommendation,
  createKnowledgeDocument,
  getKnowledgeDocuments,
  semanticSearch,
} from "../controllers/ragController";
import { authenticateToken } from "../middleware/authMiddleware";

const router = express.Router();

router.post("/knowledge", authenticateToken, createKnowledgeDocument);
router.get("/knowledge", authenticateToken, getKnowledgeDocuments);
router.get("/search", authenticateToken, semanticSearch);
router.post("/answer", authenticateToken, answerWithRetrieval);
router.post(
  "/wellness-guide",
  authenticateToken,
  createWellnessGuideRecommendation
);

export default router;
