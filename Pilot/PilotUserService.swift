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
  let endpoint = PilotConfiguration.Thunder.endpoint + "/users"

  fileprivate var basicCredentials: String

  /* Default init */
  override init() {
    basicCredentials = "\(PilotConfiguration.Thunder.userKey):\(PilotConfiguration.Thunder.userSecret)"
      .data(using: String.Encoding.utf8)!.base64EncodedString(options: [])
  }

  /// Retreives a `PilotUser` from Thunder for the given email.
  ///
  /// - note: The network call is made asynchronously.
  ///
  /// - parameters:
  ///    - email: The email to retrieve user information for.
  ///    - password: The password for the user.
  ///    - completion: The method to call upon success.
  ///    - failure: The method to call upon failure. The `HTTPStatusCode` that resulted from the network request will be passed into this method.
  ///
  func getPilotUser(_ email: String, password: String,
                    completion: @escaping (PilotUser) -> Void,
                    failure: @escaping (HTTPStatusCode) -> Void) {

    // Build the authorization headers for the request
    let headers: [String: String] = ["Authorization": "Basic \(basicCredentials)",
                                     "password": "\(password)"]

    // Build the parameters for the request
    let parameters: [String: String] = ["email": email]

    Alamofire.request(endpoint, parameters: parameters, headers: headers)
      .validate(statusCode: 200..<300)
      .responseJSON { response in
        print("Successfully retrieved user \(email).")

        // Error handling
        if response.result.isFailure {
          if let status = response.response {
            failure(HTTPStatusCode(HTTPResponse: status)!)
          } else {
            // If the response is nil, that means the server is down.
            failure(HTTPStatusCode.internalServerError)
          }

          return
        }

        // TODO: not sure if data can be nil if we make it to this point, this check may be unnecessary.
        if response.data == nil {
          failure(HTTPStatusCode.internalServerError)
          return
        }

        // Grab PilotUser from JSON response
        let json = JSON(data: response.data!)

        let user = PilotUser(
          email: json["email"].stringValue,
          password: json["password"].stringValue,
          facebookAccessToken: json["facebookAccessToken"].string,
          twitterAccessToken: json["twitterAccessToken"].string,
          twitterAccessSecret: json["twitterAccessSecret"].string)

        completion(user)
    }
  }

  /// Creates a new `PilotUser` with Thunder for the given email.
  ///
  /// - note: The network call is made asynchronously.
  ///
  /// - parameters:
  ///    - email: The email to create user information for.
  ///    - password: The password to set for the new user.
  ///    - completion: The method to call upon success.
  ///    - failure: The method to call upon failure. The `HTTPStatusCode` that resulted from the network request will be passed into this method.
  ///
  func createPilotUser(_ email: String, password: String,
                       completion: @escaping (PilotUser) -> Void,
                       failure: @escaping (HTTPStatusCode) -> Void) {
    // Build the authorization headers for the request
    let headers: [String: String] = ["Authorization": "Basic \(basicCredentials)",
      "password": "\(password)"]

    let parameters = [
      "email": email,
      "password": password
      ]

    Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
      .validate(statusCode: 200..<300)
      .responseJSON { response in
        print("Successfully created user \(email).")

        // Error handling
        if response.result.isFailure {
          if let status = response.response {
            failure(HTTPStatusCode(HTTPResponse: status)!)
          } else {
            // If the response is nil, that means the server is down.
            failure(HTTPStatusCode.internalServerError)
          }

          return
        }

        // TODO: not sure if data can be nil if we make it to this point, this check may be unnecessary.
        if response.data == nil {
          failure(HTTPStatusCode.internalServerError)
          return
        }

        // Grab PilotUser from JSON response
        let json = JSON(data: response.data!)

        let user = PilotUser(
          email: json["email"].stringValue,
          password: json["password"].stringValue,
          facebookAccessToken: json["facebookAccessToken"].string,
          twitterAccessToken: json["twitterAccessToken"].string,
          twitterAccessSecret: json["twitterAccessSecret"].string)
        
        completion(user)
    }

  }

}
