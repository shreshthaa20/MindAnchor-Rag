"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendControllerError = void 0;
const AppError_1 = require("./AppError");
const sendControllerError = (res, error, fallbackMessage) => {
    console.error(error);
    if (error instanceof AppError_1.AppError) {
        return res.status(error.statusCode).json({
            success: false,
            message: error.message,
        });
    }
    return res.status(500).json({
        success: false,
        message: fallbackMessage,
    });
};
exports.sendControllerError = sendControllerError;
