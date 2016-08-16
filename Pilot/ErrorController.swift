//
//  ErrorController.swift
//  Pilot
//
//  Created by Nick Eckert on 8/12/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa

class ErrorController: NSObject {

  static var sharedErrorController: ErrorController!

  private let viewController: MainViewController!

  init(viewController: MainViewController) {
    self.viewController = viewController
  }

  func displayError(message: String, color: NSColor = PilotColors.ErrorRed) {
    self.viewController.errorMessage.stringValue = message
    self.viewController.errorMessage.textColor = color
  }

  func clearErrors() {
    self.viewController.errorMessage.stringValue = ""
  }

}
