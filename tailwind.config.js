module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        main: '#FFD681',
        accent: '#9C661F',
        base: '#FFF5E6',
        hover: '#805A27',
        text: '#2C1803',
        placeholder: '#C5B6A8',
        subtleText: '#8F7A66',
        sweetLight: '#E6A8B8',
        sweetMedium: '#D47F92',
        sweetDeep: '#C2566D',
        firmLight: '#D4B8A8',
        firmMedium: '#C29980',
        firmDeep: '#A67C5B',
        textLight: '#F5F5F5',
      },
      fontFamily: {
        'kosugi': ['"Kosugi Maru"', 'sans-serif'],
        'rounded': ['"M PLUS Rounded 1c"', 'sans-serif'],
      },
    },
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: [
      {
        purinmania: {
          "primary": "#9C661F",
          "secondary": "#FFD681",
          "accent": "#9C661F",
          "neutral": "#2C1803",
          "base-100": "#FFF5E6",
          "info": "#3ABFF8",
          "success": "#4CAF50",
          "warning": "#FBBD23",
          "error": "#F87272",
        },
      },
    ],
    base: true,
    styled: true,
    utils: true,
    darkTheme: false,
  },
}
