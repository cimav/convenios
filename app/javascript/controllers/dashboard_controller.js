import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    show(event) {
        const userId = event.currentTarget.dataset.userId
        Turbo.visit('/dashboard/${userId}')
    }
}
