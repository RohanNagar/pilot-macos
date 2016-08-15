//
//  DirectoryService.swift
//  Pilot
//
//  Created by Nick Eckert on 6/28/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa
import FileKit

class DirectoryService: NSObject {

  static func getFilesFromPath(platformType: PlatformType, caller: FileService) -> [LocalFile]? {

    if let filePath = caller.fetchPreferences().getRootPath(platformType) {
      let platformPath = Path(filePath)

      var contents: [LocalFile] = []

      for path in platformPath {
        let file = File<NSDictionary>(path: path)

        // Cast to NSString to delete path extension
        let fileName = file.name as NSString
        let name = fileName.stringByDeletingPathExtension

        // Access the correcponsing file data stored in the DB if it exists
        if let metaData = DBController.sharedDBController.getFacebookFileByName(name) {
          contents.append(LocalFile(name: name, fileType: metaData.fileType))
        } else {
          print("File not recognized at path: \(file.path)")
        }
      }

      return contents
    }

    return nil
  }

  static func checkFile(name: String, platformType: PlatformType, caller: FileService) -> LocalFile? {

    if let filePath = caller.fetchPreferences().getRootPath(platformType) {

      print("FilePath for checkFile method: \(filePath + "/" + name)")
      let file = File<NSDictionary>(path: Path(filePath + "/" + name))

      // Cast to NSString to delete path extension
      let fileName = file.name as NSString
      let name = fileName.stringByDeletingPathExtension

      // Access the correcponsing file data stored in the DB if it exists
      if let metaData = DBController.sharedDBController.getFacebookFileByName(name) {
        return LocalFile(name: name, fileType: metaData.fileType)
      } else {
        print("File not recognized at path: \(file.path)")
      }
    }

    return nil
  }

}
