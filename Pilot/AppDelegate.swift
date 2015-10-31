//
//  AppDelegate.swift
//  Pilot
//
//  Created by Rohan Nagar on 9/26/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  var mainViewController: MainViewController!
  var loginViewController: LoginViewController!

  func applicationDidFinishLaunching(aNotification: NSNotification) {
//    window.backgroundColor = NSColor(red: 44.0/255.0, green: 181.0/255.0, blue: 233.0/255.0, alpha: 1)
    window.backgroundColor = NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)

    // Set up View Controllers
    mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
    mainViewController.setupPlatforms()

    loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)

//    window.contentView!.addSubview(mainViewController.view)
//    mainViewController.view.frame = (window.contentView! as NSView).bounds
    window.contentView!.addSubview(loginViewController.view)
    loginViewController.view.frame = (window.contentView! as NSView).bounds

    // Set constraints on loginViewController view
    loginViewController.view.translatesAutoresizingMaskIntoConstraints = false
    let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
      options: NSLayoutFormatOptions(rawValue: 0),
      metrics: nil,
      views: ["subView": loginViewController.view])
    let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
      options: NSLayoutFormatOptions(rawValue: 0),
      metrics: nil,
      views: ["subView": loginViewController.view])

    NSLayoutConstraint.activateConstraints(verticalConstraints + horizontalConstraints)
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }


}
