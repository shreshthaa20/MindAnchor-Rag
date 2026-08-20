"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const database_1 = require("./config/database");
async function testConnection() {
    try {
        const result = await database_1.pool.query("SELECT NOW()");
        console.log("Database Connected!");
        console.log(result.rows[0]);
    }
    catch (error) {
        console.error(error);
    }
    finally {
        await database_1.pool.end();
    }
}
testConnection();
