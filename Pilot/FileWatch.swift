//
//  FileWatch.swift
//  Pilot
//
//  Created by Nick Eckert on 8/6/16.
//  Copyright © 2016 Sanction. All rights reserved.
//
//  Inspiration drawn from https://blog.beecomedigital.com/2015/06/27/developing-a-filesystemwatcher-for-os-x-by-using-fsevents-with-swift-2/
//

import Foundation

public class FileWatch {

  private let pathsToWatch: [String]

  private var context = FSEventStreamContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)

  private let sinceWhen: FSEventStreamEventId!
  private let handler: (eventId: FSEventStreamEventId, eventPath: String, eventFlags: FSEventStreamEventFlags) -> ()!
  private let latency: CFTimeInterval = 0.0
  private let flags: FSEventStreamCreateFlags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)

  // Refrence to the event stream
  private var eventStream: FSEventStreamRef!

  private var started = false

  typealias FSEventStreamCallback = @convention(c) (ConstFSEventStreamRef, UnsafeMutablePointer<Void>, Int, UnsafeMutablePointer<Void>, UnsafePointer<FSEventStreamEventFlags>, UnsafePointer<FSEventStreamEventId>) -> Void
  let callback: FSEventStreamCallback = {
    (streamRef, contextInfo, numEvents, eventPaths, eventFlags, eventIds) in

    let fileWatch: FileWatch = unsafeBitCast(contextInfo, FileWatch.self)
    let paths = unsafeBitCast(eventPaths, NSArray.self) as! [String]

    for index in 0..<numEvents {
      let flag = eventFlags[index]

      // If a file was added to the directory then call the handler
      if (Int(flag) & kFSEventStreamEventFlagItemIsFile) >= 1 && (
          (Int(flag) & kFSEventStreamEventFlagItemRenamed) >= 1 ||
          (Int(flag) & kFSEventStreamEventFlagItemCreated) >= 1 ||
          (Int(flag) & kFSEventStreamEventFlagItemRemoved) >= 1) {

        fileWatch.handler(eventId: eventIds[index], eventPath: paths[index], eventFlags: eventFlags[index])
      }
    }

  }

  public init(pathsToWatch: [String], sinceWhen: FSEventStreamEventId, handler: (FSEventStreamEventId, String, FSEventStreamEventFlags) -> ()) {
    self.sinceWhen = sinceWhen
    self.pathsToWatch = pathsToWatch
    self.handler = handler
  }

  convenience public init(pathsToWatch: [String], handler: (FSEventStreamEventId, String, FSEventStreamEventFlags) -> ()) {
    self.init(pathsToWatch: pathsToWatch, sinceWhen: FSEventStreamEventId(kFSEventStreamEventIdSinceNow), handler: handler)
  }

  deinit {
    stop()
  }

  public func start() {

    guard started == false else { return }

    // Set the context
    context.info = UnsafeMutablePointer<Void>(unsafeAddressOf(self))

    // Create the event stream
    eventStream = FSEventStreamCreate(kCFAllocatorDefault, callback, &context, pathsToWatch, sinceWhen, latency, flags)

    FSEventStreamScheduleWithRunLoop(eventStream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)
    FSEventStreamStart(eventStream)

    started = true
  }

  public func stop() {

    guard started == true else { return }

    FSEventStreamStop(eventStream)
    FSEventStreamInvalidate(eventStream)
    FSEventStreamRelease(eventStream)

    eventStream = nil

    started = false
  }

}
