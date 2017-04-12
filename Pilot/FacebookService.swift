//
//  FacebookService.swift
//  Pilot
//
//  Created by Rohan Nagar on 10/3/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON
import FileKit

class FacebookService: NSObject, FileService {
  let photosEndpoint = PilotConfiguration.Lightning.endpoint + "/facebook/photos"
  let videosEndpoint = PilotConfiguration.Lightning.endpoint + "/facebook/videos"

  var pilotUser: PilotUser!

  var cachedCloudContent: [CloudFile] = []
  var cachedLocalContent: [LocalFile] = []

  var fileSystemWatcher: FileSystemWatcher!

  internal var preferences: Preferences
  internal var basicCredentials: String

  /* Default init */
  required init(preferences: Preferences, pilotUser: PilotUser) {
    self.preferences = preferences
    self.pilotUser = pilotUser

    basicCredentials = "\(PilotConfiguration.Lightning.userKey):\(PilotConfiguration.Lightning.userSecret)"
      .data(using: String.Encoding.utf8)!.base64EncodedString(options: [])
  }

  // Note: This call is asynchronous
  func refreshCachedCloudContent(_ completion: @escaping ([CloudFile]) -> ()) {
    // Fetch the photos and videos from facebook and combine them into one conglomerate
    self.getFacebookPhotos(pilotUser.email, password: pilotUser.password,
      completion: { photos in
        self.getFacebookVideos(self.pilotUser.email, password: self.pilotUser.password,
          completion: { videos in
            let returnFiles = photos + videos

            self.cachedCloudContent = returnFiles
            completion(returnFiles)
          },
          failure: { _ in
            ErrorController.sharedErrorController.displayError("Failed to retrieve video list from Facebook.")
          })
      },
      failure: { _ in
        ErrorController.sharedErrorController.displayError("Failed to retrieve photo list from Facebook.")
      })
  }

  func refreshCachedLocalContent() {
    if let directoryContents = DirectoryService.getFilesFromPath(.facebook, caller: self) {
      self.cachedLocalContent = directoryContents
    } else {
      ErrorController.sharedErrorController.displayError("Failed to load the local directory for Facebook.")
    }

  }

  func setFileSystemWatcher(_ mainViewController: MainViewController) {
    print("SetFileSystemWatcher was called")

    // Close the existing stream if it exists
    if self.fileSystemWatcher != nil {
      self.fileSystemWatcher.close()
    }

    guard let pathToWatch = preferences.getRootPath(service: .facebook) else {
      ErrorController.sharedErrorController.displayError("Pilot was unable to access the current root directory.")
      return
    }

    self.fileSystemWatcher = FileSystemWatcher(paths: [Path(pathToWatch)], flags: [.UseCFTypes, .FileEvents, .WatchRoot], callback: { event in
      let fileName = (event.path.rawValue as NSString).lastPathComponent

      if event.flags.rawValue == (FileSystemEventFlags.ItemIsFile.rawValue | FileSystemEventFlags.ItemRenamed.rawValue) {
        // Check to see if file was deleted or added
        if FileManager.default.fileExists(atPath: event.path.rawValue) {
          // If the file was added or renamed then add it to the cachedLocalContent array
          if let localFile = DirectoryService.checkFile(fileName, platformType: .facebook, caller: self) {
            self.cachedLocalContent.append(localFile)
          }
        } else {
          // File was removed from path or deleted
          let path = Path(event.path.rawValue)
          let file = File<NSDictionary>(path: path)

          // Cast to NSString to delete path extension
          let fileName = file.name as NSString
          let name = fileName.deletingPathExtension

          // Delete the realm data associated with the file that was removed
          DBController.sharedDBController.deleteFacebookFileByName(name)

          // Remove the file from the cachedLocalContent
          if let removeIndex: Int = self.cachedLocalContent.index(where: {$0.name == name}) {
            self.cachedLocalContent.remove(at: removeIndex)
          }
        }
      } else if event.flags.rawValue == FileSystemEventFlags.RootChanged.rawValue {
        // If there was a root change then attempt to create a new one based on existing preferences
        if let newRoot = self.preferences.getRootPath(service: .facebook) {
          ErrorController.sharedErrorController.displayError("Root change detected. New root created at path: \(newRoot)")
        }
      }

      // Refresh the collectionView
      mainViewController.collectionViewController.content = self.fetchCachedLocalContent()
      mainViewController.collectionViewController.collectionView.reloadData()
    })

    // Start the stream
    self.fileSystemWatcher.watch()
  }

  /// Sends a request to Lightning for all Facebook photos the user has.
  ///
  /// - note: The network request is made asynchronously.
  ///
  /// - parameters:
  ///    - email: The email of the user to retrieve photo URLs for.
  ///    - password: The passowrd of the user to retieve photo URLs for.
  ///    - completion: The method to call upon completion. Will pass in the array of photos to the method.
  ///    - failure: The method to call upon failure.
  ///
  func getFacebookPhotos(_ email: String, password: String,
                         completion: @escaping ([CloudFile]) -> Void,
                         failure: @escaping (String) -> Void) {

    // Build the authorization headers for the request
    let headers = ["Authorization": "Basic \(basicCredentials)",
                   "password": "\(password)"]

    // Build the parameters for the request
    let parameters = ["email": email]

    Alamofire.request(photosEndpoint, parameters: parameters, headers: headers)
      .responseJSON { response in
        switch response.result {
          case .success:
            // Build out array of photos from the JSON response
            var facebookPhotos = [CloudFile]()
            let json = JSON(data: response.data!)

            let photos = json.arrayValue
            for photo in photos {
              let facebookPhoto = CloudFile(
                name: photo["id"].stringValue,
                fileType: FileType.Photo,
                url: photo["url"].stringValue)

              facebookPhotos.append(facebookPhoto)
            }

            completion(facebookPhotos)

          case .failure:
            failure(response.description)
        }
    }

  }

  /// Sends a request to Lightning for all Facebook videos the user has.
  ///
  /// - note: The network request is made asynchronously.
  ///
  /// - parameters:
  ///    - email: The email of the user to retrieve videos for.
  ///    - password: The password of the user to retrieve videos for.
  ///    - completion: The method to call upon completion. Will pass in the array of videos to the method.
  ///    - failure: The method to call upon failure.
  ///
  func getFacebookVideos(_ email: String, password: String,
                         completion: @escaping ([CloudFile]) -> Void,
                         failure: @escaping (Void) -> Void) {

    // build the authorization headers for the request
    let headers = ["Authorization": "Basic \(basicCredentials)",
                   "password": "\(password)"]

    // build the parameters for the request
    let parameters = ["email": email]

    Alamofire.request(videosEndpoint, parameters: parameters, headers: headers)
      .responseJSON { response in
        switch response.result {
        case .success:
          // Build out array of photos from the JSON response
          var facebookVideos = [CloudFile]()
          let json = JSON(data: response.data!)

          let videos = json.arrayValue
          for video in videos {
            let facebookVideo = CloudFile(
              name: video["id"].stringValue,
              fileType: FileType.Video,
              url: video["url"].stringValue)

            facebookVideos.append(facebookVideo)
          }

          completion(facebookVideos)

        case .failure:
          failure()
        }
    }
  }

}
