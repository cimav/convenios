# Pin npm packages by running ./bin/importmap

# config/importmap.rb
pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers" # Si usas Stimulus # Esto hace referencia al directorio de controllers  # Ancla todos los controladores en Importmap
pin "drag_and_drop", to: "drag_and_drop.js"
pin "modal", to: "modal.js"
# pin "choices", to: "https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"
