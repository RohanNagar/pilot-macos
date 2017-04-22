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

  static func getFilesFromPath(_ platformType: PlatformType, caller: FileService) -> [LocalFile]? {

    if let filePath = caller.fetchPreferences().getRootPath(service: platformType) {
      let platformPath = Path(filePath)

      var contents: [LocalFile] = []

      for path in platformPath {
        let file = File<NSDictionary>(path: path)

        // Cast to NSString to delete path extension
        let fileName = file.name as NSString
        let name = fileName.deletingPathExtension

        // Access the correcponsing file data stored in the DB if it exists
        // TODO: should be able to get any file, not just getFacebookFileByName
        if let metaData = DBController.sharedDBController.getFacebookFileByName(name) {
          var thumbnail: NSImage

          if metaData.fileType == .Photo {
            thumbnail = NSImage(named: "PhotoFileIcon")!
          } else if metaData.fileType == .Video {
            thumbnail = NSImage(named: "VideoFileIcon")!
          } else {
            thumbnail = NSImage(named: "GenericFileIcon")!
          }

          contents.append(LocalFile(name: name, fileType: metaData.fileType, thumbnail: thumbnail))
        } else {
          print("File not recognized at path: \(file.path)")
        }
      }

      return contents
    }

    return nil
  }

  static func checkFile(_ name: String, platformType: PlatformType, caller: FileService) -> LocalFile? {

    if let filePath = caller.fetchPreferences().getRootPath(service: platformType) {

      print("FilePath for checkFile method: \(filePath + "/" + name)")
      let file = File<NSDictionary>(path: Path(filePath + "/" + name))

      // Cast to NSString to delete path extension
      let fileName = file.name as NSString
      let name = fileName.deletingPathExtension

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
