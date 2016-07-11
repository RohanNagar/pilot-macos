//
//  FacebookVideo.swift
//  Pilot
//
//  Created by Nick Eckert on 6/26/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa

class FacebookVideo: NSObject {
  var id: String
  var url: String

  init(id: String, url: String) {
    self.id = id
    self.url = url
  }

  override func isEqual(object: AnyObject?) -> Bool {
    if let obj = object as? FacebookVideo {
      return self.id == obj.id && self.url == obj.url
    }

    return false
  }

  override var description: String {
    return "PilotUser{id=\(id), url=\(url)}"
  }
}
