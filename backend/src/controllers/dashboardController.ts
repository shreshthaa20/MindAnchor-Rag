import { Response } from "express";
import { AuthRequest } from "../middleware/authMiddleware";
import { getDashboardAnalyticsForUser } from "../services/dashboardService";
import { sendControllerError } from "../utils/controllerError";

export const getDashboardAnalytics = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const dashboard = await getDashboardAnalyticsForUser(req.user?.id);

    return res.status(200).json({
      success: true,
      dashboard,
    });
  } catch (error) {
    return sendControllerError(
      res,
      error,
      "Failed to fetch dashboard analytics"
    );
  }
};
