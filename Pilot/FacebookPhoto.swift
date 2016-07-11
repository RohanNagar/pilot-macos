//
//  FacebookPhoto.swift
//  Pilot
//
//  Created by Nick Eckert on 6/26/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa

class FacebookPhoto: NSObject {

  var id: String
  var url: String
  var width: String
  var height: String

  init(id: String, url: String, width: String, height: String) {
    self.id = id
    self.url = url
    self.width = width
    self.height = height
  }

  override func isEqual(object: AnyObject?) -> Bool {
    if let obj = object as? FacebookPhoto {
      return self.id == obj.id && self.url == obj.url && self.width == obj.width && self.height == obj.height
    }

    return false
  }

  override var description: String {
    return "FacebookPhoto{id=\(id), url=\(url), width=\(width), height=\(height)}"
  }

}
