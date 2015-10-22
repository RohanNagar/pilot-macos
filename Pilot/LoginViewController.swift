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
    
    userService.getPilotUser(usernameTextField.stringValue,
      completion: { user in
        print("YES")
        print(user.username)
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
