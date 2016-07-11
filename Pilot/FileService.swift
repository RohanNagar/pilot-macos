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

  var preferences: Preferences { get }

  var user: String { get }
  var secret: String { get }
}

extension FileService {

  func download(url: String, targetLocation: String, fileName: String) {

    // Check that the download location exists and if not, make one
    checkForDirectory(targetLocation)

    let destination: (NSURL, NSHTTPURLResponse) -> NSURL = {
      (temporaryURL, response) in
      return NSURL(fileURLWithPath: "\(targetLocation), \(response.suggestedFilename!)")
    }

    // Download that file!
    Alamofire.download(.GET, url, destination: destination)
      .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
        print(totalBytesRead)

        dispatch_async(dispatch_get_main_queue()) {
          print("Total bytes read on main que: \(totalBytesRead)")
        }
      }
      .response { _, _, _, error in
        if let _ = error {
          print("Failed to download image")
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

}
