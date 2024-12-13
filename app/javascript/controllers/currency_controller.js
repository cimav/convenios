import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["amount"];

    connect() {
        this.formatCurrency();
    }

    formatCurrency() {
        const field = this.element;

        field.addEventListener("input", (event) => {
            const value = event.target.value.replace(/[^\d.-]/g, ""); // Remueve caracteres no numéricos
            if (value === "") {
                field.value = "";
                return;
            }

            const formattedValue = new Intl.NumberFormat("es-MX", {
                style: "currency",
                currency: "MXN",
                minimumFractionDigits: 2,
            }).format(parseFloat(value));

            field.value = formattedValue;
        });
    }
}
