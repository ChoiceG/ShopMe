# Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "application", to: "application.js", preload: true
pin "controllers/dashboard_controller", to: "controllers/dashboard_controller.js"
pin "controllers/products_controller", to: "controllers/products_controller.js"
pin "controllers/cart_controller", to: "controllers/cart_controller.js"
pin "controllers/alert_controller", to: "controllers/alert_controller.js"
pin "controllers/carousel_controller", to: "controllers/carousel_controller.js"
pin "controllers/data_method_controller", to: "controllers/data_method_controller.js"
pin "controllers/testimonial_carousel_controller", to: "controllers/testimonial_carousel_controller.js"
pin "controllers/dropdown_controller", to: "controllers/controller.js"

pin "chart.js", to: "https://ga.jspm.io/npm:chart.js@4.4.8/dist/chart.js" # Or a similar line
pin "@kurkle/color", to: "https://ga.jspm.io/npm:@kurkle/color@0.3.4/dist/color.esm.js"
# pin "cocoon-js", to: "https://ga.jspm.io/npm:cocoon-js@1.0.1/dist/cocoon.js" # You have this in application.js import
