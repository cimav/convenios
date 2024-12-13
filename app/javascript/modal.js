document.addEventListener("DOMContentLoaded", () => {
    const modalTriggers = document.querySelectorAll("[data-modal-target]");
    const modalCloses = document.querySelectorAll("[data-modal-close]");

    modalTriggers.forEach(trigger => {
        const modalId = trigger.getAttribute("data-modal-target");
        const modal = document.getElementById(modalId);

        if (modal) {
            trigger.addEventListener("click", () => {
                modal.classList.add("modal-open");
            });
        }
    });

    modalCloses.forEach(close => {
        const modalId = close.getAttribute("data-modal-close");
        const modal = document.getElementById(modalId);

        if (modal) {
            close.addEventListener("click", () => {
                modal.classList.remove("modal-open");
            });
        }
    });
});
