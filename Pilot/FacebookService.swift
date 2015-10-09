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

class FacebookService: NSObject {
  // Headers to use on HTTP requests to Lightning
  var headers: [String:String]

  // Endpoints to use
  let photosEndpoint = "http://localhost:9000/facebook/photos"
  let videosEndpoint = "http://localhost:9000/facebook/videos"
  
  /* Default init */
  override init() {
    let user = "lightning"
    let password = "secret"
    
    let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
    let base64Credentials = credentialData.base64EncodedStringWithOptions([])
    
    headers = ["Authorization": "Basic \(base64Credentials)"]
  }
  
  /*
   * Sends a request to Lightning for all Facebook photo URLs the user has.
   *
   * Parameters:
   *    username: The name of the user to retrieve photo URLs for.
   *    completion: The method to call upon completion. Will pass in the array of URLs to the method.
   */
  func getFacebookPhotoUrls(username: String, completion: (([String]) -> Void)) {
    Alamofire.request(.GET, photosEndpoint, headers: headers, parameters: ["username": username])
      .responseJSON { response in
        var urls = [String]()
        
        let json = JSON(data: response.data!)
        
        // Turn the JSON response into an array of Photos
        if let photos = json.array {
          // Iterate through array of photos, adding the URL of the photo to the list
          for photo in photos {
            if let url = photo["url"].string {
              urls.append(url)
            }
          }
        }
        
        // Call completion handler with array of URLs
        completion(urls)
      }
  }
  
  /*
   * Sends a request to Lightning for all Facebook video URLs the user has.
   *
   * Parameters:
   *    username: The name of the user to retrieve video URLs for.
   *    completion: The method to call upon completion. Will pass in the array of URLs to the method.
   */
  func getFacebookVideoUrls(username: String, completion: (([String]) -> Void)) {
    Alamofire.request(.GET, videosEndpoint, headers: headers, parameters: ["username": username])
      .responseJSON { response in
        var urls = [String]()
        
        let json = JSON(data: response.data!)
        
        // Turn the JSON response into an array of Photos
        if let videos = json.array {
          // Iterate through array of photos, adding the URL of the photo to the list
          for video in videos {
            if let url = video["url"].string {
              urls.append(url)
            }
          }
        }
        
        // Call completion handler with array of URLs
        completion(urls)
    }
  }
  
}
