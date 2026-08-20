import express from "express";
import {
  createMood,
  deleteMood,
  getMoods,
  updateMood,
} from "../controllers/moodController";
import { authenticateToken } from "../middleware/authMiddleware";

const router = express.Router();

router.post("/", authenticateToken, createMood);
router.get("/", authenticateToken, getMoods);
router.put("/:id", authenticateToken, updateMood);
router.delete("/:id", authenticateToken, deleteMood);

export default router;
