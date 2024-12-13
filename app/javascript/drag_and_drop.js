document.addEventListener("DOMContentLoaded", () => {
    const dropzone = document.getElementById("document_dropzone");
    const fileInput = document.getElementById("document_input");

    if (dropzone) {
        // Cambiar el color del borde al arrastrar
        dropzone.addEventListener("dragover", (event) => {
            event.preventDefault();
            dropzone.classList.remove("border-gray-300");
            dropzone.classList.add("border-blue-500");
        });

        // Restaurar el color del borde al salir del área
        dropzone.addEventListener("dragleave", () => {
            dropzone.classList.remove("border-blue-500");
            dropzone.classList.add("border-gray-300");
        });

        // Manejar el evento de soltar
        dropzone.addEventListener("drop", (event) => {
            event.preventDefault();
            dropzone.classList.remove("border-blue-500");
            dropzone.classList.add("border-gray-300");

            // Obtener los archivos del evento
            const files = event.dataTransfer.files;
            console.log("Archivo detectado:", files[0]); // Depuración
            if (files.length > 0) {
                fileInput.files = files; // Asignar el archivo al input
                dropzone.querySelector("p").textContent = `Archivo seleccionado: ${fileInput.files[0].name}`;
            }
            const addButton = document.getElementById("add_document_button");
            if (addButton) {
                addButton.disabled = (files.length === 0); // Habilita si hay un archivo seleccionado
            }

        });
    }
});
