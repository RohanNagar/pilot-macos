//
//  FacebookService.swift
//  Pilot
//
//  Created by Rohan Nagar on 10/3/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa
import Alamofire

class FacebookService: NSObject {
  // Credentials for making requests to Lightning
  let lightningCredential = NSURLCredential(user: "lightning",
                                        password: "secret",
                                     persistence: .ForSession)
  // Endpoints to use
  let photosEndpoint = "http://localhost:9000/facebook/photos"
  
  /*
   * Sends a request to Lightning for all Facebook photo URLs the user has.
   *
   * Parameters:
   *    username: The name of the user to retrieve photo URLs for.
   *    completion: The method to call upon completion. Will pass in the array of URLs to the method.
   */
  func getFacebookPhotoUrls(username: String, completion: (([String]) -> Void)) {
    Alamofire.request(.GET, photosEndpoint, parameters: ["username": username])
      .authenticate(usingCredential: lightningCredential)
      .responseJSON { response in
        var urls = [String]()
        
        // Iterate through JSON response, adding URLs to array
        if let JSON = response.result.value {
          for var i = 0; i < JSON.count; i++ {
            urls.append(JSON[i]["uri"] as! String)
          }
        }
        
        // Call completion handler with array of URLs
        completion(urls)
      }
  }
  
}
