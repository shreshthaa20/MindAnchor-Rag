"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const moodRoutes_1 = __importDefault(require("./routes/moodRoutes"));
const authRoutes_1 = __importDefault(require("./routes/authRoutes"));
const journalRoutes_1 = __importDefault(require("./routes/journalRoutes"));
const dashboardRoutes_1 = __importDefault(require("./routes/dashboardRoutes"));
const chatRoutes_1 = __importDefault(require("./routes/chatRoutes"));
const ragRoutes_1 = __importDefault(require("./routes/ragRoutes"));
const authMiddleware_1 = require("./middleware/authMiddleware");
const database_1 = require("./config/database");
dotenv_1.default.config();
const app = (0, express_1.default)();
// Request Logging Middleware
app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    next();
});
app.use((0, cors_1.default)());
app.use(express_1.default.json());
// Routes
app.use("/api/auth", authRoutes_1.default);
app.use("/api/moods", moodRoutes_1.default);
app.use("/api/journals", journalRoutes_1.default);
app.use("/api/dashboard", dashboardRoutes_1.default);
app.use("/api/chat", chatRoutes_1.default);
app.use("/api/rag", ragRoutes_1.default);
// Protected Test Route
app.get("/api/profile", authMiddleware_1.authenticateToken, (req, res) => {
    res.json({
        success: true,
        user: req.user,
    });
});
const PORT = process.env.PORT || 5000;
app.listen(PORT, async () => {
    console.log(`Server running on port ${PORT}`);
    // Run database migration to fix constraints
    try {
        const client = await database_1.pool.connect();
        console.log("Database connection successful. Migrating chat constraints...");
        await client.query("ALTER TABLE chat_messages DROP CONSTRAINT IF EXISTS chat_messages_chat_type_check");
        await client.query("ALTER TABLE chat_messages ADD CONSTRAINT chat_messages_chat_type_check CHECK (chat_type IN ('companion', 'wellness_guide'))");
        console.log("Migration successful: Allowed chat types companion and wellness_guide.");
        client.release();
    }
    catch (err) {
        console.error("Database migration error:", err);
    }
});
