//
//  PropertyListObject.swift
//
//  Created by Sereivoan Yong on 2/22/21.
//

#if canImport(Foundation)

import Foundation

@_marker
public protocol PropertyListObject { }

extension String: PropertyListObject { } // NSString
extension Int: PropertyListObject { } // NSNumber
extension Float: PropertyListObject { } // NSNumber
extension Double: PropertyListObject { } // NSNumber
extension Bool: PropertyListObject { } // NSNumber
extension Date: PropertyListObject { } // NSDate
extension Data: PropertyListObject { } // NSData
extension Array: PropertyListObject where Element: PropertyListObject { } // NSArray
extension Dictionary: PropertyListObject where Key: StringProtocol, Value: PropertyListObject { } // NSDictionary

extension NSString: PropertyListObject { }
extension NSNumber: PropertyListObject { }
extension NSDate: PropertyListObject { }
extension NSData: PropertyListObject { }
extension NSArray: PropertyListObject { }
extension NSDictionary: PropertyListObject { }

#endif
