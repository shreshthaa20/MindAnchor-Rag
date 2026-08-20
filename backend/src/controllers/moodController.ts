import { Response } from "express";
import { AuthRequest } from "../middleware/authMiddleware";
import {
  createMoodForUser,
  deleteMoodForUser,
  getMoodsForUser,
  updateMoodForUser,
} from "../services/moodService";
import { sendControllerError } from "../utils/controllerError";

// Create Mood
export const createMood = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const mood = await createMoodForUser(req.user?.id, req.body.mood);

    return res.status(201).json({
      success: true,
      mood,
    });
  } catch (error) {
    return sendControllerError(res, error, "Failed to save mood");
  }
};

// Get All Moods
export const getMoods = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const moods = await getMoodsForUser(req.user?.id);

    return res.json({
      success: true,
      moods,
    });
  } catch (error) {
    return sendControllerError(res, error, "Failed to fetch moods");
  }
};

export const updateMood = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const mood = await updateMoodForUser(
      req.user?.id,
      Number(req.params.id),
      req.body.mood
    );

    return res.status(200).json({
      success: true,
      mood,
    });
  } catch (error) {
    return sendControllerError(res, error, "Failed to update mood");
  }
};

export const deleteMood = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    await deleteMoodForUser(req.user?.id, Number(req.params.id));

    return res.status(204).send();
  } catch (error) {
    return sendControllerError(res, error, "Failed to delete mood");
  }
};
