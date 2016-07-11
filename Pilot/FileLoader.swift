//
//  FileLoader.swift
//  Pilot
//
//  Created by Nick Eckert on 6/28/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa
import FileKit

class FileLoader: NSObject {

  static func getFilesFromPath(requestPath: String) -> [PilotFile] {

    var contents: [PilotFile]!

    let directoryPath = Path(requestPath)

    // Make the directory if it's not already there
    if !directoryPath.exists {
      do {
        try directoryPath.createDirectory()
      } catch {
        print("FileKitError")
      }
    }

    for path in directoryPath {
      let file = File<NSDictionary>(path: path)
      contents.append(PilotFile(name: file.name, directory: path.rawValue, writeTime: NSDate().description))
    }

    return contents
  }

  static func countFilesInPath(requestPath: String) -> Int {
    let directoryPath = Path(requestPath)

    // Make the directory if it's not already there
    if !directoryPath.exists {
      do {
        try directoryPath.createDirectory()
      } catch {
        print("FileKitError")
      }
    }

    var count = 0

    for _ in directoryPath {
      count += 1
    }

    return count
  }

}
