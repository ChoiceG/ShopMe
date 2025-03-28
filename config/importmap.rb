# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "tailwindcss", to: "https://cdn.jsdelivr.net/npm/tailwindcss@latest/dist/tailwind.min.js"
pin "postcss", to: "https://cdn.jsdelivr.net/npm/postcss@latest/dist/postcss.min.js"
