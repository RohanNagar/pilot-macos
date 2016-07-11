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

  // The username of the user the preferences are for
  private var username: String!

  let defaults = NSUserDefaults.standardUserDefaults()

  init(rootPath: String, username: String) {
    self.rootPath = rootPath
    self.username = username
  }

  func setRootPath(rootPath: String) {
    self.rootPath = rootPath
  }

  func getRootPath() -> String {
    return rootPath
  }

  func setUsername(username: String) {
    self.username = username
  }

  func getUsername() -> String {
    return self.username
  }

  func toJSON() -> JSON {
    return JSON(["username": self.getUsername(), "rootPath": self.getRootPath()])
  }

  static func fromJSON(json: JSON) -> Preferences {
    let path = json["rootPath"].string!
    let username = json["username"].string!
    return Preferences(rootPath: path, username: username)
  }

  static func updatePreferences(preferences: Preferences) {
    let rawPreferencesJSON = preferences.toJSON().rawString()!
    NSUserDefaults.standardUserDefaults().setObject(rawPreferencesJSON, forKey: preferences.getUsername())
  }

}
