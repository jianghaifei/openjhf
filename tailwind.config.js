export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  // darkMode: ["class", '[theme-mode="dark"]'],
  plugins: [],
  safelist: [
    {
      pattern: /col-span-[1-9]/,
    },
  ],
  corePlugins: {
    preflight: false,
  },
};
