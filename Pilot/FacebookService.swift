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

class FacebookService: NSObject, FileService {

  // Content array
  var content: [LocalFile] = []

  var folderMonitor: FolderMonitor!

  // Auth keys
  let user = "lightning"
  let secret = "secret"

  // Endpoints to use
  let photosEndpoint = "http://lightning.sanctionco.com/facebook/photos"
  let videosEndpoint = "http://lightning.sanctionco.com/facebook/videos"

  internal var preferences: Preferences
  internal var basicCredentials: String

  /* Default init */
  required init(preferences: Preferences) {
    self.preferences = preferences

    basicCredentials = "\(user):\(secret)".dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions([])
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
                         failure: Void -> Void) {

    // Build the authorization headers for the request
    let headers = ["Authorization": "Basic \(basicCredentials)",
                   "password": "\(password)"]

    // Build the parameters for the request
    let parameters = ["username": username]

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
                writeTime: NSDate().description,
                url: photo["url"].stringValue)

              facebookPhotos.append(facebookPhoto)
            }

            completion(facebookPhotos)

          case .Failure:
            failure()
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
    let parameters = ["username": username]

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
              writeTime: NSDate().description,
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
