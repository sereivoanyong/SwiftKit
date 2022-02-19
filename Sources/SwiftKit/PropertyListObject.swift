//
//  PropertyListObject.swift
//
//  Created by Sereivoan Yong on 2/22/21.
//

import Foundation

@_marker
public protocol PropertyListObject { }

extension String: PropertyListObject { }
extension Data: PropertyListObject { }
extension URL: PropertyListObject { }
extension Int: PropertyListObject { }
extension Float: PropertyListObject { }
extension Double: PropertyListObject { }
extension Bool: PropertyListObject { }
extension Date: PropertyListObject { }
extension Array: PropertyListObject where Element: PropertyListObject { }
extension Dictionary: PropertyListObject where Key: StringProtocol, Value: PropertyListObject { }

extension NSString: PropertyListObject { }
extension NSData: PropertyListObject { }
extension NSURL: PropertyListObject { }
extension NSNumber: PropertyListObject { }
extension NSDate: PropertyListObject { }
extension NSArray: PropertyListObject { }
extension NSDictionary: PropertyListObject { }
