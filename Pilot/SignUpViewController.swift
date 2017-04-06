//
//  SignUpViewController.swift
//  Pilot
//
//  Created by Rohan Nagar on 4/6/17.
//  Copyright © 2017 Sanction. All rights reserved.
//

import Cocoa

class SignUpViewController: NSViewController {

  @IBOutlet weak var emailTextField: NSTextField!
  @IBOutlet weak var passwordTextField: NSTextField!
  @IBOutlet weak var confirmPasswordTextField: NSTextField!

  var signInDelegate: SignInDelegate?

  let userService = PilotUserService()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
  @IBAction func submit(_ sender: Any) {
    print("Submit")

    let password = passwordTextField.stringValue

    guard password == confirmPasswordTextField.stringValue else {
      return
    }

    let hashedPassword = PasswordService.hashPassword(password)

    userService.createPilotUser(emailTextField.stringValue, password: hashedPassword, completion: {user in
      print("Signed Up.")

      if let delegate = self.signInDelegate {
        delegate.signIn(self.view.window!, username: user.username, password: password)
      }

    }, failure: {_ in 
      print("You're dead.")
    })
  }
  
  @IBAction func back(_ sender: Any) {
    if let delegate = self.signInDelegate {
      delegate.cancel(window: self.view.window!)
    }
  }
}

protocol SignInDelegate {
  func signIn(_ window: NSWindow, username: String, password: String)
  func cancel(window: NSWindow)
}
