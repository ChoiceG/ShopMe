import "@hotwired/turbo-rails";
import "controllers";
// import 'font-awesome/css/all.css';
// import "cocoon-js";

import { Application } from "@hotwired/stimulus";
import DashboardController from "controllers/dashboard_controller"; // Correct import using the importmap name

const application = Application.start();
application.register("dashboard", DashboardController);
application.debug = true;
window.Stimulus = application;
window.application = application;