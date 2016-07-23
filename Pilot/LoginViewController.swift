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

  var mainViewController: MainViewController!
  var userService = PilotUserService()

  let defaults = NSUserDefaults.standardUserDefaults()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set the app icon image
    iconView.image = NSImage(named: "LoginIcon")

    // Change the textfield text color to custom pilot brown color
    usernameTextField.textColor = PilotColors.PilotBrownText
    passwordTextField.textColor = PilotColors.PilotBrownText
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

    // hash the password
    let hashedPassword = PasswordService.hashPassword(passwordTextField.stringValue)

    // Get the requested pilot user
    userService.getPilotUser(usernameTextField.stringValue, password: hashedPassword,
      completion: { user in

        // User is correct so try to store the password in keychain
        do {
          try Locksmith.saveData(["password": user.password], forUserAccount: user.username)
        } catch {
          // Could not load account into keychain
          print("Couldn't load the password to keychain")
        }

        // Set up the main view controller
        self.mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)

        // Set the current user in the mainViewController
        self.mainViewController.loadUser(user)

        // Load the prefrences for the user
        let preferences = self.fetchPreferences(user)
        self.mainViewController.loadUserPreferences(preferences)

        // Determine the users platforms and add them to mainViewController
        if user.facebookAccessToken != "" {
          self.mainViewController.addPlatform(Platform(title: "Facebook", icon: NSImage(named: "FacebookIcon"), type: PlatformType.Facebook))

          // Set up and load the FacebookService class
          let facebookService = FacebookService(preferences: preferences)

          // Build the facebook directory path
          let facebookURL = NSURL(fileURLWithPath: "\(preferences.getRootPath())\(PlatformType.Facebook.rawValue)//")

          // Load the files from the facebook platform directory and set them in facebookService
          let content = FileLoader.getFilesFromPath(facebookURL.path!)
          facebookService.setContent(content)

          // Create a FolderMonitoring class for the platform and set the directory path
          let folderMonitor = FolderMonitor(url: facebookURL, handler: {
            // Load files from directory into content array of service class
            self.mainViewController.facebookService!.reloadContent(PlatformType.Facebook)
            self.mainViewController.content = facebookService.content

            self.mainViewController.fileCollectionView.reloadData()
          })

          // Set the folderMonitor in facebookService
          facebookService.setFolderMonitor(folderMonitor)

          // Load the facebookService class for current user
          self.mainViewController.loadFacebookService(facebookService)
        }

        if user.twitterAccessToken != "" {
          self.mainViewController.addPlatform(Platform(title: "Twitter", icon: NSImage(named: "TwitterIcon"), type: PlatformType.Twitter))

          // Eventually load twitterService here
        }

        // Present the MainViewController to the user
        self.view.window?.contentViewController = self.mainViewController
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
    let updatePreferences = Preferences(rootPath: "\(Path.UserHome)/pilot/\(user.username)/", username: user.username)

    print("update preferences path: \(updatePreferences.getRootPath())")
    Preferences.updatePreferences(updatePreferences, username: user.username)

    return updatePreferences
  }

}

extension NSImage {

  static func swatchWithColor(color: NSColor, size: NSSize) -> NSImage {
    let image = NSImage(size: size)
    image.lockFocus()
    color.drawSwatchInRect(NSMakeRect(0, 0, size.width, size.height))
    image.unlockFocus()
    return image
  }

}
