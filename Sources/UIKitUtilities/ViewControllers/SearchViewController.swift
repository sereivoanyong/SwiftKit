//
//  SearchViewController.swift
//  UIKitUtilities
//
//  Created by Sereivoan Yong on 1/4/25.
//

import UIKit
import SwiftKit

public protocol SearchContainingController: UIViewController, UISearchBarDelegate {

  var searchBar: UISearchBar { get }
}

private var searchBarKey: Void?
extension SearchContainingController {

  public var searchBar: UISearchBar {
    if let searchBar = associatedObject(forKey: &searchBarKey, with: self) as UISearchBar? {
      return searchBar
    }
    let searchBar = UISearchBar()
    setAssociatedObject(searchBar, forKey: &searchBarKey, with: self)
    searchBar.placeholder = "Search"
    searchBar.delegate = self
    return searchBar
  }
}

@available(iOS 13.0, *)
open class SearchViewController: UIViewController, SearchContainingController {

  open private(set) var isFirstViewIsAppearing: Bool = true

  open private(set) var resultsViewController: SearchResultsViewController!

  open var searchBarBecomesFirstResponderOnViewIsAppearing: Bool = false

  open var needsSearchBarCancelButton: Bool = true

  open var hidesResultsWhenSearchTextIsBlank: Bool = false

  // MARK: Init / Deinit

  public init(resultsViewController: SearchResultsViewController? = nil) {
    self.resultsViewController = resultsViewController
    super.init(nibName: nil, bundle: nil)
    commonInit()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    navigationItem.titleView = searchBar
  }

  // MARK: View Lifecycle

  open override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground

    // Check if we have initial results view controller
    if let resultsViewController {
      configure(resultsViewController)
    } else {
      reloadResultsViewController()
    }

    updateResultsVisibility(animated: false)
  }

  open override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)

    if isFirstViewIsAppearing {
      isFirstViewIsAppearing = false
      if searchBarBecomesFirstResponderOnViewIsAppearing {
        searchBar.becomeFirstResponder()
      }
    }
  }

  func updateResultsVisibility(animated: Bool) {
    guard hidesResultsWhenSearchTextIsBlank else { return }
    let searchText = searchBar.text
    let isSearchTextBlank = searchText.isNilOrBlank
    if animated {
      UIView.animate(withDuration: 0.2) {
        self.resultsViewController.view.alpha = isSearchTextBlank ? 0 : 1
      }
    } else {
      resultsViewController.view.alpha = isSearchTextBlank ? 0 : 1
    }
  }

  /// Returns results view controller based on scope
  open func resultsViewControllerForScopeButton(at index: Int) -> SearchResultsViewController? {
    return nil
  }

  /// Reloads results view controller based on scope change
  open func reloadResultsViewController() {
    if let resultsViewController {
      resultsViewController.willMove(toParent: nil)
      resultsViewController.view.removeFromSuperview()
      resultsViewController.removeFromParent()
    }
    resultsViewController = nil

    if let newResultsViewController = resultsViewControllerForScopeButton(at: searchBar.selectedScopeButtonIndex) {
      resultsViewController = newResultsViewController
      configure(newResultsViewController)
    }
  }

  func configure(_ resultsViewController: SearchResultsViewController) {
    resultsViewController.searchText = searchBar.text
    addChild(resultsViewController)
    let resultsView = resultsViewController.view!
    resultsView.frame = view.bounds
    resultsView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    resultsView.preservesSuperviewLayoutMargins = true
    view.addSubview(resultsView)
    resultsViewController.didMove(toParent: self)
  }

  func searchTextDidChange(_ searchText: String?) {
    guard let resultsViewController else { return }
    if resultsViewController.searchText != searchText {
      resultsViewController.searchText = searchText
    }
    updateResultsVisibility(animated: true)
  }

  // MARK: UISearchBarDelegate

  open func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    reloadResultsViewController()
  }

  open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchTextDidChange(searchText)
  }

  open func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    if needsSearchBarCancelButton {
      searchBar.setShowsCancelButton(true, animated: true)
    }
  }

  open func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    if needsSearchBarCancelButton {
      searchBar.setShowsCancelButton(false, animated: true)
    }
  }

  open func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
  }

  open func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchBar.text = nil
    searchTextDidChange(searchBar.text)
  }
}
