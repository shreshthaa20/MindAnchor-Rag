import express from "express";
import { getDashboardAnalytics } from "../controllers/dashboardController";
import { authenticateToken } from "../middleware/authMiddleware";

const router = express.Router();

router.get("/", authenticateToken, getDashboardAnalytics);

export default router;
