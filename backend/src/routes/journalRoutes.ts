import express from "express";
import {
  createJournal,
  deleteJournal,
  getJournal,
  getJournals,
  updateJournal,
} from "../controllers/journalController";
import { authenticateToken } from "../middleware/authMiddleware";

const router = express.Router();

router.post("/", authenticateToken, createJournal);
router.get("/", authenticateToken, getJournals);
router.get("/:id", authenticateToken, getJournal);
router.put("/:id", authenticateToken, updateJournal);
router.delete("/:id", authenticateToken, deleteJournal);

export default router;
