import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["logsTbody", "checkbox"];

    connect() {
        this.logsTbody = document.getElementById("agreement_logs_tbody");
    }

    toggleSystemFilter() {
        const showSystemLogsOnly = this.checkbox.checked;

        fetch(`/agreements/${this.data.get("agreementId")}/logs?by_system=${showSystemLogsOnly}`)
            .then(response => response.text())
            .then(html => {
                this.logsTbody.innerHTML = html;
            });
    }
}
