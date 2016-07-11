//
//  Platform.swift
//  Pilot
//
//  Created by Rohan Nagar on 9/26/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa

class Platform: NSObject {
  var name: String
  var icon: NSImage?

  /* Default init */
  override init() {
    self.name = String()
  }

  /* Init with parameters */
  init(title: String, icon: NSImage?) {
    self.name = title
    self.icon = icon
  }

  override func isEqual(object: AnyObject?) -> Bool {
    if let obj = object as? Platform {
      return self.name == obj.name
    }

    return false
  }

  override var description: String {
    return "Platform{name=\(name), icon=\(icon)}"
  }
}

enum PlatformPath: String {
  case Twitter = "twitter"
  case Facebook = "facebook"
  case Dropbox = "dropbox"
}
