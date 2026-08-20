"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteJournal = exports.updateJournal = exports.getJournal = exports.getJournals = exports.createJournal = void 0;
const journalService_1 = require("../services/journalService");
const controllerError_1 = require("../utils/controllerError");
const createJournal = async (req, res) => {
    try {
        const journal = await (0, journalService_1.createJournalForUser)(req.user?.id, req.body.title, req.body.content);
        return res.status(201).json({
            success: true,
            journal,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to save journal");
    }
};
exports.createJournal = createJournal;
const getJournals = async (req, res) => {
    try {
        const journals = await (0, journalService_1.getJournalsForUser)(req.user?.id);
        return res.status(200).json({
            success: true,
            journals,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to fetch journals");
    }
};
exports.getJournals = getJournals;
const getJournal = async (req, res) => {
    try {
        const journal = await (0, journalService_1.getJournalForUser)(req.user?.id, Number(req.params.id));
        return res.status(200).json({
            success: true,
            journal,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to fetch journal");
    }
};
exports.getJournal = getJournal;
const updateJournal = async (req, res) => {
    try {
        const journal = await (0, journalService_1.updateJournalForUser)(req.user?.id, Number(req.params.id), req.body.title, req.body.content);
        return res.status(200).json({
            success: true,
            journal,
        });
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to update journal");
    }
};
exports.updateJournal = updateJournal;
const deleteJournal = async (req, res) => {
    try {
        await (0, journalService_1.deleteJournalForUser)(req.user?.id, Number(req.params.id));
        return res.status(204).send();
    }
    catch (error) {
        return (0, controllerError_1.sendControllerError)(res, error, "Failed to delete journal");
    }
};
exports.deleteJournal = deleteJournal;
