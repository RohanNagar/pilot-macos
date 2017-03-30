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

  // User object
  var pilotUser: PilotUser!

  // Cached cloudFiles
  var cachedCloudContent: [CloudFile] = []

  // Cached localFiles
  var cachedLocalContent: [LocalFile] = []

  var fileSystemWatcher: FileSystemWatcher!
  // Auth keys
  let user = "application"
  let secret = "secret"

  // Endpoints to use
  let photosEndpoint = "http://lightning.nickeckert.com/facebook/photos"
  let videosEndpoint = "http://lightning.nickeckert.com/facebook/videos"

  internal var preferences: Preferences
  internal var basicCredentials: String

  /* Default init */
  required init(preferences: Preferences, pilotUser: PilotUser) {
    self.preferences = preferences
    self.pilotUser = pilotUser

    basicCredentials = "\(user):\(secret)".dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions([])
  }

  // Note: This call is asynronous
  func refreshCachedCloudContent(completion: ([CloudFile]) -> ()) {
    // Fetch the photos and videos from facebook and combine them into one conglomerate
    self.getFacebookPhotos(pilotUser.username, password: pilotUser.password,
      completion: { returnPhotos in
        self.getFacebookVideos(self.pilotUser.username, password: self.pilotUser.password,
          completion: { returnVideos in
            let returnFiles = returnPhotos + returnVideos
            self.cachedCloudContent = returnFiles
            completion(returnFiles)
          },
          failure: { _ in
            ErrorController.sharedErrorController.displayError("Failed to retrieve video list from facebook")
          })
      },
      failure: { _ in
        ErrorController.sharedErrorController.displayError("Failed to retrieve photo list from facebook")
      })
  }

  func refreshCachedLocalContent() {
    if let directoryContents = DirectoryService.getFilesFromPath(.Facebook, caller: self) {
      self.cachedLocalContent = directoryContents
    } else {
      ErrorController.sharedErrorController.displayError("Failed to load directory for facebook")
    }

  }

  func setFileSystemWatcher(mainViewController: MainViewController) {
    print("SetFileSystemWatcher was called")
    // Close the existing stream if it exists
    if self.fileSystemWatcher != nil {
      self.fileSystemWatcher.close()
    }

    guard let pathToWatch = preferences.getRootPath(.Facebook) else {
      ErrorController.sharedErrorController.displayError("Pilot was unable to access the current root directory")
      return
    }

    self.fileSystemWatcher = FileSystemWatcher(paths: [Path(pathToWatch)], flags: [.UseCFTypes, .FileEvents, .WatchRoot], callback: { event in
      let fileName = (event.path.rawValue as NSString).lastPathComponent

      if event.flags.rawValue == (FileSystemEventFlags.ItemIsFile.rawValue | FileSystemEventFlags.ItemRenamed.rawValue) {
        // Check to see if file was deleted or added
        if NSFileManager.defaultManager().fileExistsAtPath(event.path.rawValue) {
          // If the file was added or renamed then add it to the cachedLocalContent array
          if let localFile = DirectoryService.checkFile(fileName, platformType: .Facebook, caller: self) {
            self.cachedLocalContent.append(localFile)
          }
        } else {
          // File was removed from path or deleted
          let path = Path(event.path.rawValue)
          let file = File<NSDictionary>(path: path)

          // Cast to NSString to delete path extension
          let fileName = file.name as NSString
          let name = fileName.stringByDeletingPathExtension

          // Delete the realm data associated with the file that was removed
          DBController.sharedDBController.deleteFacebookFileByName(name)

          // Remove the file from the cachedLocalContent
          if let removeIndex: Int = self.cachedLocalContent.indexOf({$0.name == name}) {
            self.cachedLocalContent.removeAtIndex(removeIndex)
          }
        }
      } else if event.flags.rawValue == FileSystemEventFlags.RootChanged.rawValue {
        // If there was a root change then attempt to create a new one based on existing preferences
        if let newRoot = self.preferences.getRootPath(.Facebook) {
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
  ///    - username: The name of the user to retrieve photo URLs for.
  ///    - password: The passowrd of the user to retieve photo URLs for.
  ///    - completion: The method to call upon completion. Will pass in the array of photos to the method.
  ///    - failure: The method to call upon failure.
  ///
  func getFacebookPhotos(username: String, password: String,
                         completion: [CloudFile] -> Void,
                         failure: (String) -> Void) {

    // Build the authorization headers for the request
    let headers = ["Authorization": "Basic \(basicCredentials)",
                   "password": "\(password)"]

    // Build the parameters for the request
    let parameters = ["email": username]

    Alamofire.request(.GET, photosEndpoint, headers: headers, parameters: parameters)
      .responseJSON { response in
        switch response.result {
          case .Success:
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

          case .Failure:
            failure(response.description)
        }
    }

  }

  /// Sends a request to Lightning for all Facebook videos the user has.
  ///
  /// - note: The network request is made asynchronously.
  ///
  /// - parameters:
  ///    - username: The name of the user to retrieve videos for.
  ///    - password: The password of the user to retrieve videos for.
  ///    - completion: The method to call upon completion. Will pass in the array of videos to the method.
  ///    - failure: The method to call upon failure.
  ///
  func getFacebookVideos(username: String, password: String,
                            completion: [CloudFile] -> Void,
                            failure: Void -> Void) {

    // build the authorization headers for the request
    let headers = ["Authorization": "Basic \(basicCredentials)",
                   "password": "\(password)"]

    // build the parameters for the request
    let parameters = ["email": username]

    Alamofire.request(.GET, videosEndpoint, headers: headers, parameters: parameters)
      .responseJSON { response in
        switch response.result {
        case .Success:
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

        case .Failure:
          failure()
        }
    }
  }

}
