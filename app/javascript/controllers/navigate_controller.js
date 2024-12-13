// app/javascript/controllers/navigate_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    toShow(event) {
        const url = this.element.getAttribute("data-navigate-url");
        if (url) {
            // Turbo.visit(url, { action: "replace" }); estan provocando que no sirvan los form_with del show
            window.location.href = url;
        }
    }
}
