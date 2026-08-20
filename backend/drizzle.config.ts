import { defineConfig } from "drizzle-kit";
import dotenv from "dotenv";

dotenv.config();

const sslParam = process.env.DB_HOST !== 'localhost' ? '?sslmode=require' : '';
const dbUrl = `postgresql://${process.env.DB_USER}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}${sslParam}`;

export default defineConfig({
  schema: "./src/config/schema.ts",
  out: "./drizzle",
  dialect: "postgresql",
  dbCredentials: {
    url: dbUrl,
  },
});
