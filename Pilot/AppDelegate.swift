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
  @IBOutlet weak var window: NSWindow!

  var loginViewController: LoginViewController!
  var toolbar: NSToolbar!
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {

    loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
    
    // Set up a new toolbar
    toolbar = NSToolbar(identifier: "MainViewControllerToolbar")
    toolbar.delegate = self
    window.toolbar = toolbar

    // Set the default window color
    //window.backgroundColor = NSColor.fromRGB(255.0, green: 255.0, blue: 255.0)
    
    let defaults = UserDefaults.standard

    // If there is an existing user then try to grab the password for that user from KeyChain
    if let email = defaults.string(forKey: "existingUser") {
      if let existingUserInfo = Locksmith.loadDataForUserAccount(userAccount: email) {
        let password = existingUserInfo["password"] as! String
        loginViewController.signIn(self.window, email: email, password: password)
        return
      }
    }

    // Add the loginView Controller to the contentView
    window.contentViewController = loginViewController
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application

  }

}

extension NSView {

  func bindFrameToSuperviewBounds() {
    guard let superview = self.superview else {
      return
    }

    self.translatesAutoresizingMaskIntoConstraints = false
    superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subview": self]))
    superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subview": self]))
  }

}

extension AppDelegate: NSToolbarDelegate {
  func toolbar(_ toolbar: NSToolbar,
               itemForItemIdentifier itemIdentifier: String,
               willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    return nil
  }

  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
    return []
  }

  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
    return []
  }
}
