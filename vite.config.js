import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// 'base' must match the repo name so assets load correctly on GitHub Pages:
// https://marcinsadowy.github.io/teambuilder/
export default defineConfig({
  base: '/teambuilder/',
  plugins: [react()],
});
