//
//  PilotUserService.swift
//  Pilot
//
//  Created by Rohan Nagar on 10/18/15.
//  Copyright © 2015 Sanction. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON
import HTTPStatusCodes

class PilotUserService: NSObject {
  // Headers to use on HTTP requests to Thunder
  var headers: [String: String]
  
  // Endpoint to connect to lightning
  let endpoint = "http://localhost:8080/users"

  /* Default init */
  override init() {
    // TODO pull these in from config file
    let user = "social-storm"
    let password = "67890"
    
    let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
    let base64Credentials = credentialData.base64EncodedStringWithOptions([])
    
    headers = ["Authorization": "Basic \(base64Credentials)"]
  }
  
  /**
   * Retreives a `PilotUser` from Thunder for the given username.
   *
   * - note: The network call is made asynchronously.
   *
   * - parameters:
   *    - username: The name to retrieve user information for.
   *    - completion: The method to call upon success.
   *    - failure: The method to call upon failure. The `HTTPStatusCode` that resulted from the network request will be passed into this method.
   */
  func getPilotUser(username: String,
                    completion: PilotUser -> Void,
                    failure: HTTPStatusCode -> Void) {
      Alamofire.request(.GET, endpoint, headers: headers, parameters: ["username": username])
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          
          // Error handling
          if response.result.isFailure {
            if let status = response.response {
              failure(HTTPStatusCode(HTTPResponse: status)!)
            } else {
              // If the response is nil, that means the server is down.
              failure(HTTPStatusCode.InternalServerError)
            }
            
            return
          }
          
          // TODO not sure if data can be nil if we make it to this point, this check may be unnecessary.
          if response.data == nil {
            failure(HTTPStatusCode.InternalServerError)
            return
          }
          
          // Grab PilotUser from JSON response
          let json = JSON(data: response.data!)
          
          let user = PilotUser(
            username: json["username"].stringValue,
            password: json["password"].stringValue,
            facebookAccessToken: json["facebookAccessToken"].stringValue,
            twitterAccessToken: json["twitterAccessToken"].stringValue,
            twitterAccessSecret: json["twitterAccessSecret"].stringValue)
          
          completion(user)
        }
  }
  
}
