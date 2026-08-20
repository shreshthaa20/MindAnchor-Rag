"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteMood = exports.updateMood = exports.getMoods = exports.createMood = void 0;
const moodService_1 = require("../services/moodService");
const controllerError_1 = require("../utils/controllerError");
// Create Mood
const createMood = async (req, res) => {
    try {
        const mood = await (0, moodService_1.createMoodForUser)(req.user?.id, req.body.mood);
        return res.status(201).json({
            success: true,
            mood,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to save mood");
    }
};
exports.createMood = createMood;
// Get All Moods
const getMoods = async (req, res) => {
    try {
        const moods = await (0, moodService_1.getMoodsForUser)(req.user?.id);
        return res.json({
            success: true,
            moods,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to fetch moods");
    }
};
exports.getMoods = getMoods;
const updateMood = async (req, res) => {
    try {
        const mood = await (0, moodService_1.updateMoodForUser)(req.user?.id, Number(req.params.id), req.body.mood);
        return res.status(200).json({
            success: true,
            mood,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to update mood");
    }
};
exports.updateMood = updateMood;
const deleteMood = async (req, res) => {
    try {
        await (0, moodService_1.deleteMoodForUser)(req.user?.id, Number(req.params.id));
        return res.status(204).send();
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to delete mood");
    }
};
exports.deleteMood = deleteMood;
