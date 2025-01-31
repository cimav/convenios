// app/javascript/controllers/filter_controller.js
import { Controller } from "@hotwired/stimulus"

let agreementRows = []
export default class extends Controller {
    static targets = ["agreementRow"]

    connect() {
        agreementRows = this.agreementRowTargets
    }

    search(event) {

        if (agreementRows.length === 0) {
            console.warn("No targets found in search, possible context issue.");
            return
        }

        const query = event.target.value.toLowerCase().trim();
        const terms = query.split(" ");

        agreementRows.forEach(agreementRow => {

            const titleEle = agreementRow.querySelector("[data-title]");
            const clientEle = agreementRow.querySelector("[data-client]");
            const requesterEle = agreementRow.querySelector("[data-requester]");
            //const creatorEle = agreementRow.querySelector("[data-creator]");
            //const acronymEle = agreementRow.querySelector("[data-acronym]");
            const statusEle = agreementRow.querySelector("[data-status]");
            const codeEle = agreementRow.querySelector("[data-code]");

            const title = agreementRow.getAttribute("data-title")?.toLowerCase() || "";
            const client = agreementRow.getAttribute("data-client")?.toLowerCase() || "";
            const requester = agreementRow.getAttribute("data-requester")?.toLowerCase() || "";
            //const creator = agreementRow.getAttribute("data-creator")?.toLowerCase() || "";
            //const acronym = agreementRow.getAttribute("data-acronym")?.toLowerCase() || "";
            const status = agreementRow.getAttribute("data-status")?.toLowerCase() || "";
            const code = agreementRow.getAttribute("data-code")?.toLowerCase() || "";

            // Verifica si cada término de búsqueda está en `title` o `companyName`
            const matches = terms.every(
                term => code.includes(term) || title.includes(term) || client.includes(term)
                    ||  status.includes(term) || requester.includes(term)

                // creator.includes(term)  || acronym.includes(term)  ||

                // "data-creator" => @creators_on_agreements[agreement.creator_id.to_s.rjust(5, '0')]&.nombre,
                // %td{"data-solicitante-name" => @creators_on_agreements[agreement.creator_id.to_s.rjust(5, '0')]&.nombre}= @creators_on_agreements[agreement.creator_id.to_s.rjust(5, '0')]&.nombre

                // "data-acronym" => agreement.type_acronym,
            )

            // Muestra u oculta la fila según si coincide con todos los términos
            agreementRow.style.display = matches ? "" : "none"

            // Resaltar términos si hay coincidencias
            if (matches) {
                this.highlightMatches(titleEle, terms);
                this.highlightMatches(clientEle, terms);
                this.highlightMatches(requesterEle, terms);
                // this.highlightMatches(creatorEle, terms);
                // this.highlightMatches(acronymEle, terms);
                this.highlightMatches(statusEle, terms);
                this.highlightMatches(codeEle, terms);
            } else {
                // Limpiar resaltado si no hay coincidencias
                this.clearHighlights(titleEle);
                this.clearHighlights(clientEle);
                this.clearHighlights(requesterEle);
                // this.clearHighlights(creatorEle);
                // this.clearHighlights(acronymEle);
                this.clearHighlights(statusEle);
                this.clearHighlights(codeEle);
            }


        });
    }

    highlightMatches(element, terms) {
        if (!element) return;

        let innerHTML = element.textContent;

        terms.forEach(term => {
            // const regex = new RegExp(`(${term})`, "gi"); // Busca términos sin importar mayúsculas o minúsculas
            const regex = new RegExp(`(${term})(?![^<]*>)`, "gi"); // Busca el término ignorando etiquetas HTML
            innerHTML = innerHTML.replace(regex, "<mark>$1</mark>"); // Envuelve los términos en <mark>
        });

        element.innerHTML = innerHTML; // Actualiza el contenido con los términos resaltados
    }

    clearHighlights(element) {
        if (!element) return;

        // Reemplaza los <mark> con texto normal
        element.innerHTML = element.textContent;
    }

}
