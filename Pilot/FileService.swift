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

  var basicCredentials: String { get }

  func refreshCachedCloudContent(_ completion: @escaping ([CloudFile]) -> ()) -> Void

  func refreshCachedLocalContent() -> Void

  func setFileSystemWatcher(_ mainViewController: MainViewController) -> Void
}

extension FileService {

  func download(_ fileToDownload: CloudFile, platformType: PlatformType, failure: @escaping (CloudFile) -> ()) {

    if let path = preferences.getRootPath(service: platformType) {

      let destination: DownloadRequest.DownloadFileDestination =  {
        (temporaryURL, response) in
        let responseName: NSString = response.suggestedFilename! as NSString
        let pathExtension = responseName.pathExtension

        return (URL(fileURLWithPath: path).appendingPathComponent("\(fileToDownload.name).\(pathExtension)"), [])
      }

      // Download that file!
      Alamofire.download(fileToDownload.url, to: destination)
        .downloadProgress { progress in
          // print("\(totalBytesRead/totalBytesExpectedToRead*100)%")

          DispatchQueue.main.async {
            // print("Total bytes read on main que: \(totalBytesRead)")
          }
        }
        .responseData { response in
          if let _ = response.error {
            print("Download failed!")
            failure(fileToDownload)
          } else {
            print("Downloaded succeeded!")
          }
      }
    }
  }

  func upload(_ files: [URL], to url: String, forUser user: PilotUser) {
    for file in files {
      upload(file, to: url, forUser: user)
    }
  }

  func upload(_ file: URL, to url: String, forUser user: PilotUser) {
    // Build the location of file to upload
    //let fileURL = Bundle.main.url(forResource: "~/desktop/test", withExtension: "png")

    // Build the authorization headers for the request
    let headers = ["Authorization": "Basic \(basicCredentials)",
      "password": "\(user.password)"]

    // Build the parameters for the request
    // TODO: get type from file extension
    //let parameters = ["email": user.email, "type": "photo"]


    Alamofire.upload(
      multipartFormData: { multipartFormData in
        multipartFormData.append(file, withName: "file")
      },
      to: "\(url)?email=\(user.email)&type=photo",
      headers: headers,
      encodingCompletion: { encodingResult in
        switch encodingResult {
          case .success(let upload, _, _):
            upload.responseString { response in
              debugPrint(response)
            }
          case .failure(let encodingError):
            print(encodingError)
          }
      }
    )

//    Alamofire.upload(file, to: url)
//      .uploadProgress { progress in
//        print(progress.fractionCompleted)
//
//        DispatchQueue.main.async {
//          // print("Total bytes written on main queue: \(totalBytesWritten)")
//        }
//      }
//      .responseJSON { response in
//        debugPrint(response)
//    }
  }

  func fetchCachedCloudContent() -> [CloudFile] {
    return self.cachedCloudContent
  }

  func fetchCachedLocalContent() -> [LocalFile] {
    return self.cachedLocalContent
  }

  func setFileSystemWatcher(_ fileSystemWatcher: FileSystemWatcher) {
    self.fileSystemWatcher = fileSystemWatcher
  }

  func fetchPreferences() -> Preferences {
    return self.preferences
  }

}
