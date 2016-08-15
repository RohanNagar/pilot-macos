//
//  DBController.swift
//  Pilot
//
//  Created by Nick Eckert on 7/31/16.
//  Copyright © 2016 Sanction. All rights reserved.
//

import Cocoa
import RealmSwift

class DBController: NSObject {

  static let sharedDBController = DBController()

  var realm: Realm!

  // Initialzie DBController by attempting to create connection to DB
  override init() {
    do {
      realm = try Realm()
    } catch {
      ErrorController.sharedErrorController.displayError("Unable to make connection with Real DB")
    }
  }

  // Create a facebookFile to store in realmDB
  func createFacebookFile(file: CloudFile, completion: (LocalFile) -> ()) {
    do {
      try realm.write {
        let fbPhoto = FacebookFile()
        fbPhoto.name = file.name
        fbPhoto.fileTypeRaw = file.fileType.rawValue
        fbPhoto.height? = file.height!
        fbPhoto.width? = file.width!

        realm.add(fbPhoto)

        // Construct a LocalFile to be returned upon completion
        let returnFile = LocalFile(name: file.name, fileType: file.fileType)
        completion(returnFile)
      }
    } catch {
        // Throw appropriate error
    }
  }

  // Update a file stored in realmDB by providing a name
  func updateFacebookFile(file: CloudFile) {

  }

  // Delete a file stored in realmDB by providing a name
  func deleteFacebookFileByName(name: String) {
    if let fileToDelete = getFacebookFileByName(name) {
      do {
        try realm.write {
          realm.delete(fileToDelete)
        }
      } catch {
        print("File failed to delete!")
        // Throw error later
      }
    }
  }

  // Query a file stored in realmDB by providing a name
  func getFacebookFileByName(name: String) -> FacebookFile? {
    // Create the appropriate predicate for filtering a fesult by name
    let predicate = NSPredicate(format: "name = %@", name)

    return realm.objects(FacebookFile.self).filter(predicate).first
  }

}

class FacebookFile: Object {
  dynamic var name = ""
  dynamic var size = 0
  dynamic var fileTypeRaw = ""
  var fileType: FileType {
    get {
      return FileType(rawValue: fileTypeRaw)!
    }
  }
  dynamic var height: String? = nil
  dynamic var width: String? = nil

  // FacebookFile objects are indexed by name for faster lookup
  override static func indexedProperties() -> [String] {
    return ["name"]
  }

}
