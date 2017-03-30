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

  // Auth keys
  let user = "lightning"
  let secret = "secret"

  // Endpoint to connect to Thunder
  let endpoint = "http://thunder.nickeckert.com/users"

  private var basicCredentials: String

  /* Default init */
  override init() {
    basicCredentials = "\(user):\(secret)".dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions([])
  }

  /// Retreives a `PilotUser` from Thunder for the given username.
  ///
  /// - note: The network call is made asynchronously.
  ///
  /// - parameters:
  ///    - username: The name to retrieve user information for.
  ///    - completion: The method to call upon success.
  ///    - failure: The method to call upon failure. The `HTTPStatusCode` that resulted from the network request will be passed into this method.
  ///
  func getPilotUser(username: String, password: String,
                    completion: PilotUser -> Void,
                    failure: HTTPStatusCode -> Void) {

    // Build the authorization headers for the request
    let headers: [String: String] = ["Authorization": "Basic \(basicCredentials)",
                                     "password": "\(password)"]

    // Build the parameters for the request
    let parameters: [String: String] = ["email": username]

    Alamofire.request(.GET, endpoint, headers: headers, parameters: parameters)
      .validate(statusCode: 200..<300)
      .responseJSON { response in

        print(response.timeline)

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

        // TODO: not sure if data can be nil if we make it to this point, this check may be unnecessary.
        if response.data == nil {
          failure(HTTPStatusCode.InternalServerError)
          return
        }

        // Grab PilotUser from JSON response
        let json = JSON(data: response.data!)

        let user = PilotUser(
          username: json["email"].stringValue,
          password: json["password"].stringValue,
          facebookAccessToken: json["facebookAccessToken"].stringValue,
          twitterAccessToken: json["twitterAccessToken"].stringValue,
          twitterAccessSecret: json["twitterAccessSecret"].stringValue)

        completion(user)
    }
  }

}
