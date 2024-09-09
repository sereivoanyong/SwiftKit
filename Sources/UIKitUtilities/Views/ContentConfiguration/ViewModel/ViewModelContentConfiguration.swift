//
//  ViewModelContentConfiguration.swift
//
//  Created by Sereivoan Yong on 9/9/24.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
open class ViewModelContentConfiguration<ContentView: ViewModelContentView>: AnyViewModelContentConfiguration<ContentView.ViewModel> {

  open override func makeContentView() -> UIView & UIContentView {
    let contentView: ContentView
    if let contentViewClass = ContentView.self as? (UIView & NibLoadable).Type {
      contentView = contentViewClass.loadFromNib() as! ContentView
    } else {
      contentView = ContentView()
    }
    contentView.viewModelConfiguration = self
    return contentView
  }
}
