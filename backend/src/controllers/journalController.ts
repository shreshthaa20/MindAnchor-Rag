import { Response } from "express";
import { AuthRequest } from "../middleware/authMiddleware";
import {
  createJournalForUser,
  deleteJournalForUser,
  getJournalForUser,
  getJournalsForUser,
  updateJournalForUser,
} from "../services/journalService";
import { sendControllerError } from "../utils/controllerError";

export const createJournal = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const journal = await createJournalForUser(
      req.user?.id,
      req.body.title,
      req.body.content
    );

    return res.status(201).json({
      success: true,
      journal,
    });
  } catch (error) {
    return sendControllerError(
      res,
      error,
      "Failed to save journal"
    );
  }
};

export const getJournals = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const journals = await getJournalsForUser(req.user?.id);

    return res.status(200).json({
      success: true,
      journals,
    });
  } catch (error) {
    return sendControllerError(
      res,
      error,
      "Failed to fetch journals"
    );
  }
};

export const getJournal = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const journal = await getJournalForUser(
      req.user?.id,
      Number(req.params.id)
    );

    return res.status(200).json({
      success: true,
      journal,
    });
  } catch (error) {
    return sendControllerError(
      res,
      error,
      "Failed to fetch journal"
    );
  }
};

export const updateJournal = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const journal = await updateJournalForUser(
      req.user?.id,
      Number(req.params.id),
      req.body.title,
      req.body.content
    );

    return res.status(200).json({
      success: true,
      journal,
    });
  } catch (error) {
    return sendControllerError(
      res,
      error,
      "Failed to update journal"
    );
  }
};

export const deleteJournal = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    await deleteJournalForUser(req.user?.id, Number(req.params.id));

    return res.status(204).send();
  } catch (error) {
    return sendControllerError(
      res,
      error,
      "Failed to delete journal"
    );
  }
};
