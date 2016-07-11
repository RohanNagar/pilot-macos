//
//  File.swift
//  Pilot
//
//  Created by Rohan Nagar on 1/22/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa

class PilotFile: NSObject {
  var name: String
  var size: Int
  var thumbnail: NSImage?
  var directory: String
  var writeTime: String
  var id: String

  convenience init(name: String, directory: String, writeTime: String) {
    self.init(name: name, size: 0, thumbnail: Optional.None, directory: directory, writeTime: writeTime, id: "")
  }

  init(name: String, size: Int, thumbnail: NSImage?, directory: String, writeTime: String, id: String) {
    self.name = name
    self.size = size
    self.thumbnail = thumbnail
    self.directory = directory
    self.writeTime = writeTime
    self.id = id
  }

  override func isEqual(object: AnyObject?) -> Bool {
    if let obj = object as? PilotFile {
      return self.name == obj.name
    }

    return false
  }

  override var description: String {
    return "File{name=\(name), size=\(size)}"
  }

}
