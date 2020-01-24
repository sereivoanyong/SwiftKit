//
//  IndexPath.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(Foundation)
import Foundation

extension IndexPath {
  
  public init(row: Int) {
    self.init(row: row, section: 0)
  }
  
  public init(item: Int) {
    self.init(item: item, section: 0)
  }
  
  public init<Section>(row: Int, section: Section) where Section: RawRepresentable, Section.RawValue == Int {
    self.init(row: row, section: section.rawValue)
  }
  
  public init<Section>(item: Int, section: Section) where Section: RawRepresentable, Section.RawValue == Int {
    self.init(item: item, section: section.rawValue)
  }
}
#endif
