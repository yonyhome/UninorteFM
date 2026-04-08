import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#D42020",
        "primary-dark": "#A81818",
        "primary-light": "#E84040",
        dark: "#000000",
        "gray-mid": "#666666",
        "gray-light": "#DBDBDB",
        "gray-xlight": "#F3F4F4",
      },
      fontFamily: {
        mulish: ["Mulish", "sans-serif"],
        carrois: ["Carrois Gothic SC", "sans-serif"],
      },
      animation: {
        "pulse-slow": "pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite",
        "bar": "bar 1.2s ease-in-out infinite",
        "spin-slow": "spin 8s linear infinite",
      },
      keyframes: {
        bar: {
          "0%, 100%": { transform: "scaleY(0.3)" },
          "50%": { transform: "scaleY(1)" },
        },
      },
    },
  },
  plugins: [],
};

export default config;
