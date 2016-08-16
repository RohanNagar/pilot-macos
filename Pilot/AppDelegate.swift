//
//  AppDelegate.swift
//  Pilot
//
//  Created by Rohan Nagar on 9/26/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa
import FileKit
import Locksmith

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var loginWindow: NSWindow!

  var loginViewController: LoginViewController!

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)

    let defaults = NSUserDefaults.standardUserDefaults()

    // If there is an existing user then try to grab the password for that user from KeyChain
    if let username = defaults.stringForKey("existingUser") {
      if let existingUserInfo = Locksmith.loadDataForUserAccount(username) {
        let password = existingUserInfo["password"] as! String
        loginViewController.signIn(loginWindow, username: username, password: password)
        return
      }
    }

    // Add the loginView Controller to the contentView
    loginWindow.contentViewController = loginViewController
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application

  }

}
