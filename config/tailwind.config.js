const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    "./app/views/**/*.html.haml",
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',

    './app/views/**/*.html.erb',
    './app/views/**/*.html.haml',

    './app/assets/stylesheets/**/*.css',

  ],
  safelist: [
    "btn", "btn-primary", "btn-secondary", "btn-accent", "btn-outline",
    "btn-circle", "btn-lg", "btn-sm",
    'text-customOrange-500', // Agrega las clases personalizadas aquí. Avoid el PurgeCSS
    'text-customPurple-500'
  ],  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        customOrange: {
          500: '#f97316', // Código HEX de Tailwind predeterminado para `orange-500`
        },
        customPurple: {
          500: '#a855f7', // Código HEX de Tailwind predeterminado para `purple-500`
        },
      },
    },
  },
  plugins: [
    require("daisyui"),
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries')

  ],
  daisyui: {
    themes: ["corporate"], // Establece el tema a "corporate"
  },
}
