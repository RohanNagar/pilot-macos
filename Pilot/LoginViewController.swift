//
//  LoginViewController.swift
//  Pilot
//
//  Created by Rohan Nagar on 10/18/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa
import HTTPStatusCodes

class LoginViewController: NSViewController {

  @IBOutlet weak var usernameTextField: NSTextField!
  @IBOutlet weak var passwordTextField: NSSecureTextField!

  let userService = PilotUserService()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }

  /// Called when `usernameTextField` sends an action.
  ///
  /// - parameters
  ///   - sender: The `NSTextField` object that sent the action.
  ///
  @IBAction func didEndUsernameEditing(sender: NSTextField) {
    if sender != usernameTextField {
      return
    }

    print("Username did end editing")
    passwordTextField.becomeFirstResponder()
  }

  /// Called when `passwordTextField sends an action.
  ///
  /// - parameters:
  ///    - sender: The `NSSecureTextField` object that sent the action.
  ///
  @IBAction func didEndPasswordEditing(sender: NSSecureTextField) {
    if sender != passwordTextField {
      return
    }

    print("Password did end editing")
    passwordTextField.resignFirstResponder()
    signIn(sender)
  }

  /// Called when the sign in button is pressed.
  ///
  /// - parameters:
  ///    - sender: The object that send the action.
  ///
  @IBAction func signIn(sender: AnyObject) {
    print("Pressed sign in.")
    print("Username: \(usernameTextField.stringValue)")
    print("Password: \(passwordTextField.stringValue)")

    let hashedPassword = PasswordService.hashPassword(passwordTextField.stringValue)
    print("Hashed password: \(hashedPassword)")

    userService.getPilotUser(usernameTextField.stringValue,
      completion: { user in
        print("Found user.")
        print(user.username)

        if hashedPassword != user.password {
          print("Password does not match.")
          return
        }

        print("Password matches")
        self.view.window?.contentViewController = (NSApplication.sharedApplication().delegate as! AppDelegate).mainViewController
      },
      failure: { statusCode in
        switch statusCode {
        case HTTPStatusCode.BadRequest:
          print("Bad input, please fix and try again.")
        case HTTPStatusCode.NotFound:
          print("Unable to find username in database. Please try again or sign up.")
        case HTTPStatusCode.InternalServerError:
          print("Unable to connect to database. Please file a report and try again later.")
        default:
          print("WTF")
        }
      })

  }

}
