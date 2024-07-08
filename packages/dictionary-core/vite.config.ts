import { defineConfig } from "@natsuneko-laboratory/kiana/vite";

export default defineConfig({
  externals: ["csv-parse/sync", "node:fs/promises"],
});
