import { Response } from "express";
import { AppError } from "./AppError";

export const sendControllerError = (
  res: Response,
  error: unknown,
  fallbackMessage: string
) => {
  console.error(error);

  if (error instanceof AppError) {
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
