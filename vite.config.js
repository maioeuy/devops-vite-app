import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react'; // or vue(), etc.

export default defineConfig({
  plugins: [react()], // or your chosen framework plugin
  server: {
    host: '0.0.0.0', // This is crucial for Docker
    port: 5173,      // Ensure this matches your Docker port mapping
    watch: {
      usePolling: true // Sometimes necessary for file changes in Docker
    }
  }
});