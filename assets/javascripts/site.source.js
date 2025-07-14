import { Application } from "@hotwired/stimulus"
import ThemeController from "./controllers/theme_controller"

// Initialize Stimulus application
const application = Application.start()

// Register controllers
application.register("theme", ThemeController)

// Export for potential use elsewhere
window.Stimulus = application
