//
//  LoginViewController.swift
//  Pilot
//
//  Created by Rohan Nagar on 10/18/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa
import HTTPStatusCodes
import SwiftyJSON
import FileKit
import Locksmith

class LoginViewController: NSViewController {

  @IBOutlet weak var signInButton: NSButton!
  @IBOutlet weak var iconView: NSImageView!
  @IBOutlet weak var usernameTextField: NSTextField!
  @IBOutlet weak var passwordTextField: NSSecureTextField!
  @IBOutlet weak var message: NSTextField!

  var userService = PilotUserService()

  let defaults = NSUserDefaults.standardUserDefaults()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.wantsLayer = true
    
    // Disable window resize for the login window
    self.view.window!.styleMask &= ~NSResizableWindowMask

    // Set the app icon image
    iconView.image = NSImage(named: "LoginIcon")

    // Change the textfield text color to custom pilot brown color
    usernameTextField.textColor = PilotColors.PilotBrownText
    passwordTextField.textColor = PilotColors.PilotBrownText
  }
  
  override func awakeFromNib() {
    if self.view.layer != nil {
      let color: CGColorRef = PilotColors.White.CGColor
      self.view.layer?.backgroundColor = color
    }
  }
  
  override func viewDidAppear() {
    self.view.window!.backgroundColor = PilotColors.PilotBlue
    
    self.view.window!.titleVisibility = NSWindowTitleVisibility.Hidden
    self.view.window!.titlebarAppearsTransparent = true
    self.view.window!.movableByWindowBackground = true
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

    passwordTextField.resignFirstResponder()
    signInButton(sender)
  }

  /// Called when the sign in button is pressed.
  ///
  /// - parameters:
  ///    - sender: The object that send the action.
  ///
  @IBAction func signInButton(sender: AnyObject) {
    if usernameTextField.stringValue == "" || passwordTextField.stringValue == "" {
      message.stringValue = "Cannot have an empty username or password field"
      return
    }

    signIn(self.view.window!, username: usernameTextField.stringValue, password: passwordTextField.stringValue)
  }

  func signIn(window: NSWindow, username: String, password: String) {

    // hash the password
    let hashedPassword = PasswordService.hashPassword(password)

    // Get the requested pilot user
    userService.getPilotUser(username, password: hashedPassword,
      completion: { user in
        // Store the username in NSUserDefaults as the existingUser
        self.defaults.setObject(user.username, forKey: "existingUser")

        // Attempt to store the password for that user in KeyChain
        do {
          try Locksmith.saveData(["password": password], forUserAccount: user.username)
        } catch LocksmithError.Duplicate {
          print("Duplicate with LockSmith")
        } catch {
          print("There was an error with LockSmith")
        }

        // Set up the main view controller
        guard let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil) else {
          return
        }

        // Set up the ErrorController class
        let errorController = ErrorController(viewController: mainViewController)
        ErrorController.sharedErrorController = errorController

        // Set the current user in the mainViewController
        mainViewController.loadUser(user)

        // Load the prefrences for the user
        let preferences = self.fetchPreferences(user)
        mainViewController.loadUserPreferences(preferences)

        // Determine the users platforms and add them to mainViewController
        if user.facebookAccessToken != "" {
          mainViewController.addPlatform(Platform(title: "Facebook", icon: NSImage(named: "FacebookIcon"), type: .Facebook))

          // Set up and load the FacebookService class
          let facebookService = FacebookService(preferences: preferences, pilotUser: user)

          // Set the FileSystemWatcher class for facebook
          facebookService.setFileSystemWatcher(mainViewController)

          // Attempt to grab facebook cloud files and call the DirectoryService
          facebookService.refreshCachedLocalContent()

          // Load the facebookService class for current user
          mainViewController.loadFacebookService(facebookService)
        }

        if user.twitterAccessToken != "" {
          mainViewController.addPlatform(Platform(title: "Twitter", icon: NSImage(named: "TwitterIcon"), type: PlatformType.Twitter))

          // Eventually load twitterService here
        }

        // Enable window resize for mainViewController
        window.styleMask |= NSResizableWindowMask

        // Present the MainViewController to the user
        window.contentViewController = mainViewController
      },
      failure: { statusCode in
        switch statusCode {
        case HTTPStatusCode.Unauthorized:
          self.message.stringValue = "Invalid authentication credentials."
        case HTTPStatusCode.BadRequest:
          self.message.stringValue = "Bad input, please fix and try again."
        case HTTPStatusCode.NotFound:
          self.message.stringValue = "Unable to find username in database. Please try again or sign up."
        case HTTPStatusCode.InternalServerError:
          self.message.stringValue = "Unable to connect to database. Please file a report and try again later."
        default:
          self.message.stringValue = "WTF"
        }
      })
  }

  func fetchPreferences(user: PilotUser) -> Preferences {
    // Grab the raw JSON from userDefualts as a String
    if let rawStringJSON = self.defaults.objectForKey(user.username) as? String {

      // Creat a JSON object and convert it to an object of type Preferences
      return Preferences.fromJSON(JSON.parse(rawStringJSON))
    }

    // If that failes register default preferences
    return self.registerDefaultPreferences(user)
  }

  func registerDefaultPreferences(user: PilotUser) -> Preferences {
    let updatePreferences = Preferences(rootPath: "\(Path.UserHome)/pilot/\(user.username)/")

    Preferences.updatePreferences(updatePreferences, username: user.username)

    return updatePreferences
  }

}
