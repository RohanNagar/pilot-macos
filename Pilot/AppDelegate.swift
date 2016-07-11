//
//  AppDelegate.swift
//  Pilot
//
//  Created by Rohan Nagar on 9/26/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa
import FileKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  var loginViewController: LoginViewController!

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)

    // Add the loginView Controller to the contentView
    if let contentView = window.contentView {
      contentView.addSubview(loginViewController.view)
    }
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application

  }

}
