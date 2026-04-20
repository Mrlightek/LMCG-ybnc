// ── app/javascript/controllers/index.js ─────────────────────────
import { application } from "./application"

import NavController             from "./nav_controller"
import RevealController          from "./reveal_controller"
import CounterController         from "./counter_controller"
import NewsletterFormController  from "./newsletter_form_controller"
import ToastController           from "./toast_controller"
import EventFilterController     from "./event_filter_controller"

application.register("nav",              NavController)
application.register("reveal",           RevealController)
application.register("counter",          CounterController)
application.register("newsletter-form",  NewsletterFormController)
application.register("toast",            ToastController)
application.register("event-filter",     EventFilterController)