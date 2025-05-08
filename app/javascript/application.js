import "@hotwired/turbo-rails";
import "controllers";
// import 'font-awesome/css/all.css';
// import "cocoon-js";

import { Application } from "@hotwired/stimulus";
// import DashboardController from "controllers/dashboard_controller"; // Correct import using the importmap name
// import ProductsController from "controllers/products_controller"; // Correct import using the importmap name
// import CartController from "controllers/cart_controller";
// import AlertController from "controllers/alert_controller";
// import CarouselController from "controllers/carousel_controller";
// import DataMethodController from "controllers/data_method_controller;"
import MobileNavController from "controllers/mobile_nav_controller";

const application = Application.start();
// application.register("dashboard", DashboardController);
// application.register("products", ProductsController);
// application.register("cart", CartController);
// application.register("alert", AlertController);
// application.register("carousel", CarouselController)
// application.register("data_method", DataMethodController);
application.register("mobile_nav", MobileNavController);
application.debug = true;
window.Stimulus = application;
window.application = application;


