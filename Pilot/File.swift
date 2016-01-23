//
//  File.swift
//  Pilot
//
//  Created by Rohan Nagar on 1/22/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa

class File: NSObject {
  var name: String
  var size: Int
  var thumbnail: NSImage?

  override init() {
    self.name = "Name"
    self.size = 0
  }

  init(name: String, size: Int, thumbnail: NSImage?) {
    self.name = name
    self.size = size
    self.thumbnail = thumbnail
  }

  override func isEqual(object: AnyObject?) -> Bool {
    if let obj = object as? File {
      return self.name == obj.name
    }

    return false
  }

  override var description: String {
    return "File{name=\(name), size=\(size)}"
  }

}
