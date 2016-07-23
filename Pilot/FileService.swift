//
//  FileService.swift
//  Pilot
//
//  Created by Nick Eckert on 6/26/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa
import Alamofire
import FileKit

protocol FileService: NSObjectProtocol {
  init(preferences: Preferences)

  // Local copy of CloudFile's for faster access when interfacting with collectionView
  var content: [LocalFile] { get set }

  // FolderMonitor class for updating collectionView given a folder change occures
  var folderMonitor: FolderMonitor! { get set }

  var preferences: Preferences { get }

  var user: String { get }
  var secret: String { get }
}

extension FileService {

  func download(url: String, platformType: PlatformType, fileName: String) {

    let path = "\(self.preferences.getRootPath())\(platformType.rawValue)"

    // Check that the download location exists and if not, make one
    checkForDirectory(path)

    let destination: (NSURL, NSHTTPURLResponse) -> NSURL = {
      (temporaryURL, response) in
      let responseName: NSString = response.suggestedFilename!
      let pathExtension = responseName.pathExtension

      return NSURL(fileURLWithPath: path).URLByAppendingPathComponent("\(fileName).\(pathExtension)")
    }

    // Download that file!
    Alamofire.download(.GET, url, destination: destination)
      .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
        print("\(totalBytesRead/totalBytesExpectedToRead*100)%")

        dispatch_async(dispatch_get_main_queue()) {
          // print("Total bytes read on main que: \(totalBytesRead)")
        }
      }
      .response { _, _, _, error in
        if let _ = error {
          print("Failed to download file")
        } else {
          print("Downloaded file successfully")
        }
    }
  }

  func upload(url: String, file: String) {

    // Build the location of file to upload
    let fileURL = NSBundle.mainBundle().URLForResource("~/desktop/test", withExtension: "png")

    // Check this bitch instead of force unwrapping!
    Alamofire.upload(.POST, url, file: fileURL!)
      .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
        print(totalBytesWritten)

        dispatch_async(dispatch_get_main_queue()) {
          print("Total bytes written on main queue: \(totalBytesWritten)")
        }
      }
      .responseJSON { response in
        debugPrint(response)
    }
  }

  private func checkForDirectory(directory: String) -> Bool {
    let directoryPath = Path(directory)

    if !directoryPath.exists {
      do {
        try directoryPath.createDirectory()
      } catch {
        print("Problem making directory")
        return false
      }
    }

    return true
  }

  func setContent(data: [LocalFile]) {
    self.content = data
  }

  func reloadContent(platformType: PlatformType) {
    let path = "\(preferences.getRootPath())\(platformType.rawValue)"
    self.content = FileLoader.getFilesFromPath(path)
    print()
  }

  func setFolderMonitor(folderMonitor: FolderMonitor) {
    self.folderMonitor = folderMonitor
  }

}
