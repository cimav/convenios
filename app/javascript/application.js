// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

// app/javascript/application.js
import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

import "@hotwired/turbo-rails"
import "drag_and_drop";
import "modal" // Archivo donde se encuentra el script del modal
// import CurrencyController from "./controllers/currency_controller";

// Inicializa Stimulus y carga todos los controladores de manera anticipada
const application = Application.start()
eagerLoadControllersFrom("controllers", application)
// application.register("currency", CurrencyController);


Turbo.start()
console.log("Stimulus and Turbo loaded Oka")
// import Choices from "choices";

