//
//  File.swift
//  Pilot
//
//  Created by Rohan Nagar on 1/22/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

// This class should work with both photos, videos, as well as cloud files

import Cocoa
import RealmSwift

protocol PilotFile: class {
  var name: String { get }
  var fileType: FileType { get set }
  var size: Int? { get set }
  var thumbnail: NSImage? { get set }
  var directory: String? { get set }

  func setSize(_ size: Int)

  func setThumbNail(_ thumbnail: NSImage)

  func setTargetDirectory(_ directory: String)

}

extension PilotFile {

  func isEqual(_ object: AnyObject) -> Bool {
    if let obj = object as? PilotFile {
      return self.name == obj.name
    }

    return false
  }

  var description: String {
    return "File{name=\(name), size=\(String(describing: size)), directory=\(String(describing: directory))}"
  }

}

enum FileType: String {
  case Photo = "photo"
  case Video = "video"
}
