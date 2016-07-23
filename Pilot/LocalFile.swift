//
//  LocalFile.swift
//  Pilot
//
//  Created by Nick Eckert on 7/19/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa

class LocalFile: NSObject, PilotFile {
  var name: String
  var writeTime: String
  var size: Int?
  var fileType: FileType?
  var thumbnail: NSImage?
  var directory: String?
  var width: String?
  var height: String?

  convenience init(name: String, writeTime: String) {
    self.init(name: name, writeTime: writeTime, size: nil, fileType: nil, thumbnail: nil, directory: nil, width: nil, height: nil)
  }

  init(name: String, writeTime: String, size: Int?, fileType: FileType?, thumbnail: NSImage?, directory: String?, width: String?, height: String?) {
    self.name = name
    self.writeTime = writeTime
    self.size = size
    self.fileType = fileType
    self.thumbnail = thumbnail
    self.directory = directory
    self.width = width
    self.height = height
  }

  func setSize(size: Int) {
    self.size = size
  }

  func setFileType(fileType: FileType) {
    self.fileType = fileType
  }

  func setThumbNail(thumbnail: NSImage) {
    self.thumbnail = thumbnail
  }

  func setTargetDirectory(directory: String) {
    self.directory = directory
  }

}
