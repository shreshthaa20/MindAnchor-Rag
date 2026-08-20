import express from "express";
import {
  getCurrentUser,
  registerUser,
  loginUser,
} from "../controllers/authController";
import { authenticateToken } from "../middleware/authMiddleware";

const router = express.Router();

// Authentication Routes
router.post("/register", registerUser);
router.post("/login", loginUser);
router.get("/me", authenticateToken, getCurrentUser);

export default router;
