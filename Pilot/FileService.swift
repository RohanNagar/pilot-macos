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
  init(preferences: Preferences, pilotUser: PilotUser)

  // PilotUser object
  var pilotUser: PilotUser! { get set }

  // Local copy of CloudFile's
  var cachedCloudContent: [CloudFile] { get set }

  // Local copy of LocalFiles for faster access when interfacting with collectionView
  var cachedLocalContent: [LocalFile] { get set }

  // FileWatch class for updating collectionView given a folder change occures
  var fileSystemWatcher: FileSystemWatcher! { get set }

  var preferences: Preferences { get }

  var user: String { get }
  var secret: String { get }

  func refreshCachedCloudContent(completion: ([CloudFile]) -> ()) -> Void

  func refreshCachedLocalContent() -> Void

  func setFileSystemWatcher(mainViewController: MainViewController) -> Void
}

extension FileService {

  func download(fileToDownload: CloudFile, platformType: PlatformType, failure: (CloudFile) -> ()) {

    if let path = preferences.getRootPath(platformType) {

      let destination: (NSURL, NSHTTPURLResponse) -> NSURL = {
        (temporaryURL, response) in
        let responseName: NSString = response.suggestedFilename!
        let pathExtension = responseName.pathExtension

        return NSURL(fileURLWithPath: path).URLByAppendingPathComponent("\(fileToDownload.name).\(pathExtension)")
      }

      // Download that file!
      Alamofire.download(.GET, fileToDownload.url, destination: destination)
        .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
          // print("\(totalBytesRead/totalBytesExpectedToRead*100)%")

          dispatch_async(dispatch_get_main_queue()) {
            // print("Total bytes read on main que: \(totalBytesRead)")
          }
        }
        .response { _, _, _, error in
          if let _ = error {
            print("Download failed!")
            failure(fileToDownload)
          } else {
            print("Downloaded succeeded!")
          }
      }
    }
  }

  func upload(url: String, file: String) {

    // Build the location of file to upload
    let fileURL = NSBundle.mainBundle().URLForResource("~/desktop/test", withExtension: "png")

    Alamofire.upload(.POST, url, file: fileURL!)
      .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
        print(totalBytesWritten)

        dispatch_async(dispatch_get_main_queue()) {
          // print("Total bytes written on main queue: \(totalBytesWritten)")
        }
      }
      .responseJSON { response in
        debugPrint(response)
    }
  }

  func fetchCachedCloudContent() -> [CloudFile] {
    return self.cachedCloudContent
  }

  func fetchCachedLocalContent() -> [LocalFile] {
    return self.cachedLocalContent
  }

  func setFileSystemWatcher(fileSystemWatcher: FileSystemWatcher) {
    self.fileSystemWatcher = fileSystemWatcher
  }

  func fetchPreferences() -> Preferences {
    return self.preferences
  }

}
