package controllers

import play.api.mvc.{Action, Controller}

/**
 * A controller class with four action methods.
 */
class Products extends Controller {

  def list(page: Int) = Action {         // #1 Show product list
    NotImplemented
  }

  def details(ean: Long) = Action {      // #2 Show product details
    NotImplemented
  }

  def edit(ean: Long) = Action {         // #3 Edit product details
    NotImplemented
  }

  def update(ean: Long) = Action {       // #4 Update product details
    NotImplemented
  }
}