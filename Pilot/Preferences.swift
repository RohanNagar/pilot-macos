//
//  Prefrences.swift
//  Pilot
//
//  Created by Nick Eckert on 6/30/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Preferences: NSObject {

  // The base url to use for file storage
  private var rootPath: String!

  let defaults = NSUserDefaults.standardUserDefaults()

  init(rootPath: String, username: String) {
    self.rootPath = rootPath
  }

  func setRootPath(rootPath: String) {
    self.rootPath = rootPath
  }

  func getRootPath() -> String {
    return rootPath
  }

  func toJSON() -> JSON {
    return JSON(["rootPath": self.getRootPath()])
  }

  static func fromJSON(json: JSON) -> Preferences {
    let path = json["rootPath"].string!
    let username = json["username"].string!
    return Preferences(rootPath: path, username: username)
  }

  static func updatePreferences(preferences: Preferences, username: String) {
    let rawPreferencesJSON = preferences.toJSON().rawString()!
    NSUserDefaults.standardUserDefaults().setObject(rawPreferencesJSON, forKey: username)
  }

}
