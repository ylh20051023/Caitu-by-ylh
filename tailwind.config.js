/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './index.html',
    './src/**/*.{vue,js,ts,jsx,tsx}'
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#2563EB',
          hover: '#1D4ED8',
          pressed: '#1E40AF'
        },
        success: '#22C55E',
        warning: '#F59E0B',
        error: '#EF4444',
        bg: '#F9FAFB',
        card: '#FFFFFF',
        text: {
          DEFAULT: '#1F2937',
          secondary: '#6B7280'
        }
      },
      maxWidth: {
        'content': '1200px'
      }
    }
  },
  plugins: []
}
