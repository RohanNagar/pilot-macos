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
  var type: PlatformType

  /* Init with parameters */
  init(title: String, icon: NSImage?, type: PlatformType) {
    self.name = title
    self.icon = icon
    self.type = type
  }

  override func isEqual(_ object: Any?) -> Bool {
    if let obj = object as? Platform {
      return self.name == obj.name
    }

    return false
  }

  override var description: String {
    return "Platform{name=\(name), icon=\(String(describing: icon))}"
  }
}

enum PlatformType: String {
  case twitter = "twitter"
  case facebook = "facebook"
  case dropbox = "dropbox"
}
