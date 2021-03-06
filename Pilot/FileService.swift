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
  var pilotUser: PilotUser! { get set }

  // Local copies of CloudFiles and LocalFiles
  var cachedCloudContent: [CloudFile] { get set }
  var cachedLocalContent: [LocalFile] { get set }

  // FileWatch class for updating the collection view when a folder change occures
  var fileSystemWatcher: FileSystemWatcher! { get set }

  var preferences: Preferences { get }
  var basicCredentials: String { get }

  init(preferences: Preferences, pilotUser: PilotUser)

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

  func upload(_ files: [URL], to url: String) {
    for file in files {
      upload(file, to: url)
    }
  }

  func upload(_ file: URL, to url: String) {
    // Build the authorization headers for the request
    let headers = ["Authorization": "Basic \(basicCredentials)",
      "password": "\(pilotUser.password)"]

    // TODO: get type from file
    let type = "photo"

    Alamofire.upload(
      multipartFormData: { multipartFormData in
        multipartFormData.append(file, withName: "file")
      },
      to: "\(url)?email=\(pilotUser.email)&type=\(type)",
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
