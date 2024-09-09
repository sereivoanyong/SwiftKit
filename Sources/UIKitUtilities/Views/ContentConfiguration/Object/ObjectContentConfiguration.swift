//
//  ObjectContentConfiguration.swift
//
//  Created by Sereivoan Yong on 9/16/24.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
open class ObjectContentConfiguration<ContentView: ObjectContentView>: AnyObjectContentConfiguration<ContentView.Object> {

  open override func makeContentView() -> UIView & UIContentView {
    let contentView: ContentView
    if let contentViewClass = ContentView.self as? (UIView & NibLoadable).Type {
      contentView = contentViewClass.loadFromNib() as! ContentView
    } else {
      contentView = ContentView()
    }
    contentView.objectConfiguration = self
    return contentView
  }
}
