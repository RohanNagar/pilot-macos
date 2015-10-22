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
    let user = "social-storm"
    let password = "67890"
    
    let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
    let base64Credentials = credentialData.base64EncodedStringWithOptions([])
    
    headers = ["Authorization": "Basic \(base64Credentials)"]
  }
  
  func getPilotUser(username: String,
                    completion: PilotUser -> Void,
                    failure: HTTPStatusCode -> Void) {
      Alamofire.request(.GET, endpoint, headers: headers, parameters: ["username": username])
        .responseJSON { response in
          
          // Error handling
          if response.result.isFailure {
            if let status = response.response {
              let code = HTTPStatusCode(HTTPResponse: status)!
              failure(code)
            } else {
              failure(HTTPStatusCode.InternalServerError)
            }
            
            return
          }
          
          if let status = response.response where status.statusCode != 200 {
            let code = HTTPStatusCode(HTTPResponse: status)!
            failure(code)
            return
          }
          
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
