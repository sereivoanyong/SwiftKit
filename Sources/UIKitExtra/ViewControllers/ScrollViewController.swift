//
//  ScrollViewController.swift
//
//  Created by Sereivoan Yong on 3/6/21.
//

#if os(iOS)

import UIKit

open class ScrollViewController: UIViewController {

  open class var scrollViewClass: UIScrollView.Type {
    return UIScrollView.self
  }

  lazy public private(set) var scrollView: UIScrollView = {
    let scrollView = Self.scrollViewClass.init(frame: UIScreen.main.bounds)
    scrollView.backgroundColor = .clear
    scrollView.alwaysBounceHorizontal = false
    scrollView.alwaysBounceVertical = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = true
    scrollView.preservesSuperviewLayoutMargins = true
    scrollView.delegate = self as? UIScrollViewDelegate
    return scrollView
  }()

  open var isScrollViewRoot: Bool = false

  open override func loadView() {
    if isScrollViewRoot {
      view = scrollView
    } else {
      super.loadView()
    }
  }

  open override func viewDidLoad() {
    super.viewDidLoad()

    if !isScrollViewRoot {
      scrollView.frame = view.bounds
      scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      view.addSubview(scrollView)
    }
  }
}

#endif
