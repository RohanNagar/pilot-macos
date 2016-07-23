//
//  File.swift
//  Pilot
//
//  Created by Rohan Nagar on 1/22/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

// This class should work with both photos, videos, as well as cloud files

import Cocoa

protocol PilotFile: class {
  var name: String { get }
  var writeTime: String { get }
  var size: Int? { get set }
  var fileType: FileType? { get set }
  var thumbnail: NSImage? { get set }
  var directory: String? { get set }

  func setSize(size: Int)

  func setFileType(fileType: FileType)

  func setThumbNail(thumbnail: NSImage)

  func setTargetDirectory(directory: String)

}

extension PilotFile {

  func isEqual(object: AnyObject) -> Bool {
    if let obj = object as? PilotFile {
      return self.name == obj.name
    }

    return false
  }

  var description: String {
    return "File{name=\(name), size=\(size), writeTime=\(writeTime), directory=\(directory)}"
  }

}

enum FileType {
  case Photo
  case Video
  case Document
}
