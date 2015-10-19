//
//  LoginViewController.swift
//  Pilot
//
//  Created by Rohan Nagar on 10/18/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {

  @IBOutlet weak var usernameTextField: NSTextField!
  @IBOutlet weak var passwordTextField: NSTextField!
  
  let userService = PilotUserService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }
  
  
  @IBAction func signIn(sender: AnyObject) {
    print("Pressed sign in.")
    print("Username: \(usernameTextField.stringValue)")
    print("Password: \(passwordTextField.stringValue)")
    
    let hashedPassword = PasswordService.hashPassword(passwordTextField.stringValue)
    print("Hashed password: \(hashedPassword)")
  }
  
}
