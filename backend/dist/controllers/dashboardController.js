"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getDashboardAnalytics = void 0;
const dashboardService_1 = require("../services/dashboardService");
const controllerError_1 = require("../utils/controllerError");
const getDashboardAnalytics = async (req, res) => {
    try {
        const dashboard = await (0, dashboardService_1.getDashboardAnalyticsForUser)(req.user?.id);
        return res.status(200).json({
            success: true,
            dashboard,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to fetch dashboard analytics");
    }
};
exports.getDashboardAnalytics = getDashboardAnalytics;
