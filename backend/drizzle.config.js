"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const drizzle_kit_1 = require("drizzle-kit");
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
const dbUrl = `postgresql://${process.env.DB_USER}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`;
exports.default = (0, drizzle_kit_1.defineConfig)({
    schema: "./src/config/schema.ts",
    out: "./drizzle",
    dialect: "postgresql",
    dbCredentials: {
        url: dbUrl,
    },
});
