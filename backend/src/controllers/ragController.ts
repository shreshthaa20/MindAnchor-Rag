import { Response } from "express";
import { AuthRequest } from "../middleware/authMiddleware";
import {
  answerWithRetrievalForUser,
  createKnowledgeDocumentForUser,
  createWellnessGuideRecommendationForUser,
  getKnowledgeDocumentsForUser,
  semanticSearchForUser,
} from "../services/ragService";
import { sendControllerError } from "../utils/controllerError";

export const createKnowledgeDocument = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const document = await createKnowledgeDocumentForUser(
      req.user?.id,
      req.body.title,
      req.body.content,
      req.body.source,
      req.body.category,
      req.body.tags
    );

    return res.status(201).json({
      success: true,
      document,
    });
  } catch (error) {
    return sendControllerError(
      res,
      error,
      "Failed to create knowledge document"
    );
  }
};

export const createWellnessGuideRecommendation = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const result = await createWellnessGuideRecommendationForUser(
      req.user?.id,
      req.body.question
    );

    return res.status(201).json({
      success: true,
      userMessage: result.userMessage,
      assistantMessage: result.assistantMessage,
      sources: result.sources,
    });
  } catch (error) {
    return sendControllerError(
      res,
      error,
      "Failed to generate wellness guide recommendation"
    );
  }
};

export const getKnowledgeDocuments = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const documents = await getKnowledgeDocumentsForUser(req.user?.id);

    return res.status(200).json({
      success: true,
      documents,
    });
  } catch (error) {
    return sendControllerError(
      res,
      error,
      "Failed to fetch knowledge documents"
    );
  }
};

export const semanticSearch = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const results = await semanticSearchForUser(
      req.user?.id,
      req.query.query,
      req.query.limit
    );

    return res.status(200).json({
      success: true,
      results,
    });
  } catch (error) {
    return sendControllerError(
      res,
      error,
      "Failed to run semantic search"
    );
  }
};

export const answerWithRetrieval = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    const result = await answerWithRetrievalForUser(
      req.user?.id,
      req.body.question
    );

    return res.status(200).json({
      success: true,
      answer: result.answer,
      sources: result.sources,
    });
  } catch (error) {
    return sendControllerError(
      res,
      error,
      "Failed to generate RAG answer"
    );
  }
};
