//
//  SearchResultsViewController.swift
//  UIKitUtilities
//
//  Created by Sereivoan Yong on 1/7/25.
//

import UIKit

public protocol SearchResultsViewController: UIViewController {

  var searchText: String? { get set }
}

extension SearchResultsViewController {

  @available(iOS 13.0, *)
  public var searchViewController: SearchViewController? {
    var parent = parent
    while let parentToFind = parent {
      if let parentToFind = parentToFind as? SearchViewController {
        return parentToFind
      }
      parent = parentToFind.parent
    }
    return nil
  }

  @available(iOS 13.0, *)
  public func embeddingInSearchViewController() -> SearchViewController {
    return SearchViewController(resultsViewController: self)
  }
}
