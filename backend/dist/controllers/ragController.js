"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.answerWithRetrieval = exports.semanticSearch = exports.getKnowledgeDocuments = exports.createWellnessGuideRecommendation = exports.createKnowledgeDocument = void 0;
const ragService_1 = require("../services/ragService");
const controllerError_1 = require("../utils/controllerError");
const createKnowledgeDocument = async (req, res) => {
    try {
        const document = await (0, ragService_1.createKnowledgeDocumentForUser)(req.user?.id, req.body.title, req.body.content, req.body.source, req.body.category, req.body.tags);
        return res.status(201).json({
            success: true,
            document,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to create knowledge document");
    }
};
exports.createKnowledgeDocument = createKnowledgeDocument;
const createWellnessGuideRecommendation = async (req, res) => {
    try {
        const result = await (0, ragService_1.createWellnessGuideRecommendationForUser)(req.user?.id, req.body.question);
        return res.status(201).json({
            success: true,
            userMessage: result.userMessage,
            assistantMessage: result.assistantMessage,
            sources: result.sources,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to generate wellness guide recommendation");
    }
};
exports.createWellnessGuideRecommendation = createWellnessGuideRecommendation;
const getKnowledgeDocuments = async (req, res) => {
    try {
        const documents = await (0, ragService_1.getKnowledgeDocumentsForUser)(req.user?.id);
        return res.status(200).json({
            success: true,
            documents,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to fetch knowledge documents");
    }
};
exports.getKnowledgeDocuments = getKnowledgeDocuments;
const semanticSearch = async (req, res) => {
    try {
        const results = await (0, ragService_1.semanticSearchForUser)(req.user?.id, req.query.query, req.query.limit);
        return res.status(200).json({
            success: true,
            results,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to run semantic search");
    }
};
exports.semanticSearch = semanticSearch;
const answerWithRetrieval = async (req, res) => {
    try {
        const result = await (0, ragService_1.answerWithRetrievalForUser)(req.user?.id, req.body.question);
        return res.status(200).json({
            success: true,
            answer: result.answer,
            sources: result.sources,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to generate RAG answer");
    }
};
exports.answerWithRetrieval = answerWithRetrieval;
