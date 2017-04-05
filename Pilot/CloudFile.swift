//
//  CloudFile.swift
//  Pilot
//
//  Created by Nick Eckert on 7/19/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa

class CloudFile: NSObject, PilotFile {
  var name: String
  var fileType: FileType
  var url: String
  var size: Int?
  var thumbnail: NSImage?
  var directory: String?
  var width: String?
  var height: String?

  convenience init(name: String, fileType: FileType, url: String) {
    self.init(name: name, fileType: fileType, url: url, size: nil, thumbnail: nil, directory: nil, width: nil, height: nil)
  }

  init(name: String, fileType: FileType, url: String, size: Int?, thumbnail: NSImage?, directory: String?, width: String?, height: String?) {
    self.name = name
    self.fileType = fileType
    self.url = url
    self.size = size
    self.thumbnail = thumbnail
    self.directory = directory
    self.width = width
    self.height = height
  }

  func setSize(_ size: Int) {
    self.size = size
  }

  func setThumbNail(_ thumbnail: NSImage) {
    self.thumbnail = thumbnail
  }

  func setTargetDirectory(_ directory: String) {
    self.directory = directory
  }

}
