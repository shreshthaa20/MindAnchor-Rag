"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const database_1 = require("./config/database");
async function run() {
    try {
        const res = await database_1.pool.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public'
    `);
        console.log("TABLES IN DATABASE:", res.rows.map(r => r.table_name));
        for (const row of res.rows) {
            const colRes = await database_1.pool.query(`
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = $1
      `, [row.table_name]);
            console.log(`\nTable ${row.table_name} columns:`);
            console.log(colRes.rows.map(c => `${c.column_name} (${c.data_type})`));
        }
    }
    catch (err) {
        console.error("Error listing schema:", err);
    }
    finally {
        await database_1.pool.end();
    }
}
run();
