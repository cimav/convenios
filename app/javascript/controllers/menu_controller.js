// app/javascript/controllers/menu_controller.js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {
  static targets = ["dropdown"]

  connect() {

    document.addEventListener("turbo:load", () => {
      if (!this.hasDropdownTarget) {
        console.error("Dropdown target not found on turbo:load")
      } else {
        console.log("Dropdown target found on turbo:load")
      }
    })


    // Detecta clics fuera del menú
    document.addEventListener("click", this.closeOnClickOutside.bind(this))

  }

  disconnect() {
    // Elimina el event listener al desconectar el controlador
    document.removeEventListener("click", this.closeOnClickOutside.bind(this))
  }

  toggle() {
    this.dropdownTarget.classList.toggle("hidden")
  }

  closeOnClickOutside(event) {
    // Si el clic ocurre fuera del menú y no en el elemento que abre el menú, cierra el menú
    if (this.dropdownTarget.classList.contains("hidden")) return

    if (!this.element.contains(event.target)) {
      this.dropdownTarget.classList.add("hidden")
    }
  }


}
