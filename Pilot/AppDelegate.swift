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

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    mainViewController = MainViewController(nibName:"MainViewController", bundle:nil)
    mainViewController.setupPlatforms()
    
    window.contentView!.addSubview(mainViewController.view)
    mainViewController.view.frame = (window.contentView! as NSView).bounds
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }


}
