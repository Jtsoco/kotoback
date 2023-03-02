// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { Application } from '@hotwired/stimulus'


const application = Application.start()


import HelloController from "./hello_controller"
application.register("hello", HelloController)

import BookController from "./book_controller"
application.register("book", BookController)
