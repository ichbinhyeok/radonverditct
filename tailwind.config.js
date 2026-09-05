/** @type {import('tailwindcss').Config} */
module.exports = {
    content: [
        "./src/main/jte/**/*.jte",
        "./src/main/resources/static/**/*.js"
    ],
    theme: {
        extend: {
            fontFamily: {
                sans: ['"Source Sans 3"', 'sans-serif'],
                display: ['Fraunces', 'serif'],
            },
            colors: {
                paper: {
                    DEFAULT: '#F2EEE4',
                    light: '#FBFAF6',
                    rule: '#CFC8B8',
                },
                ink: '#142019',
                pine: '#245542',
                signal: '#DDF56B',
                brand: {
                    50: '#f8fafc',
                    100: '#f1f5f9',
                    400: '#94a3b8',
                    500: '#64748b',
                    600: '#475569',
                    900: '#0f172a', /* Deep slate navy for premium feel */
                }
            }
        }
    },
    plugins: [],
}
