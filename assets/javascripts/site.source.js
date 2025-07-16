import { Application } from "@hotwired/stimulus"
import ThemeController from "./controllers/theme_controller"
import TabsController from "./controllers/tabs_controller"

// Initialize Stimulus application
const application = Application.start()

// Register controllers
application.register("theme", ThemeController)
application.register("tabs", TabsController)

// Export for potential use elsewhere
window.Stimulus = application
