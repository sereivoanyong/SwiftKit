//
//  NotificationCenter.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/30/26.
//

import Foundation
import Combine

extension NotificationCenter {

  /// Returns a publisher that emits events when broadcasting notifications.
  ///
  /// - Parameters:
  ///   - name: The name of the notification to publish.
  ///   - object: The object posting the named notfication. If `nil`, the publisher emits elements for any object producing a notification with the given name.
  /// - Returns: A publisher that emits events when broadcasting notifications.
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  public func objectPublisher<T: AnyObject>(for name: Notification.Name, object: T) -> some Combine.Publisher<T, Never> {
    return publisher(for: name, object: object)
      .map { $0.object as! T }
  }
}
