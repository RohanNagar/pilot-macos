//
//  Prefrences.swift
//  Pilot
//
//  Created by Nick Eckert on 6/30/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa
import SwiftyJSON
import FileKit

class Preferences: NSObject {

  // The root path will be created once when the user logs in for the first time. After that the user will have to specify a new rootPath if the
  // old one was deleted

  // The base url to use for file storage
  private var rootPath: String!

  init(rootPath: String) {
    self.rootPath = rootPath
  }

  func setRootPath(rootPath: String) {
    self.rootPath = rootPath
  }

  func getRootPath(forService: PlatformType) -> String? {
    let rootServicePath = Path(rootPath + forService.rawValue)

    // If the path doesn't exist then attempt to make a new one
    guard rootServicePath.exists else {
      do {
        try rootServicePath.createDirectory()

        return rootServicePath.rawValue
      } catch FileKitError.CreateDirectoryFail(path: rootServicePath) {
        ErrorController.sharedErrorController.displayError(String(FileKitError.CreateDirectoryFail(path: rootServicePath)))
        return nil
      } catch {
        ErrorController.sharedErrorController.displayError("Unknown Error: Pilot cannot access the current root directory. Consider changing this in preferences and try again.")
        return nil
      }
    }

    // Return the path if it checks out
    return rootServicePath.rawValue
  }

  func toJSON() -> JSON {
    return JSON(["rootPath": self.rootPath])
  }

  static func fromJSON(json: JSON) -> Preferences {
    let path = json["rootPath"].string!
    return Preferences(rootPath: path)
  }

  static func updatePreferences(preferences: Preferences, username: String) {
    let rawPreferencesJSON = preferences.toJSON().rawString()!
    NSUserDefaults.standardUserDefaults().setObject(rawPreferencesJSON, forKey: username)
  }

}
