//
//  CollectionViewController.swift
//
//  Created by Sereivoan Yong on 3/5/21.
//

import UIKit

open class CollectionViewController: UIViewController {

  /// If this property is `true`, `collectionView` and `view` are the same.
  open var isCollectionViewRoot: Bool = false

  open var invalidatesLayoutOnViewWillTransition: Bool = true

  private var _collectionView: UICollectionView!

  open weak var collectionView: UICollectionView! {
    get {
      if _collectionView == nil {
        loadCollectionView()
        collectionViewDidLoad()
      }
      return _collectionView
    }
    set {
      precondition(_collectionView == nil, "Collection view can only be set before it is loaded.")
      _collectionView = newValue
      collectionViewDidLoad()
    }
  }

  private var _collectionViewLayout: UICollectionViewLayout!
  open var collectionViewLayout: UICollectionViewLayout {
    if let _collectionViewLayout {
      return _collectionViewLayout
    }
    if let _collectionView {
      _collectionViewLayout = _collectionView.collectionViewLayout
    } else {
      _collectionViewLayout = makeCollectionViewLayout()
    }
    return _collectionViewLayout
  }

  // MARK: Collection View Lifecycle

  open func makeCollectionViewLayout() -> UICollectionViewLayout {
    fatalError("\(#function) has not been implemented")
  }

  open func loadCollectionView() {
    let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: collectionViewLayout)
    collectionView.backgroundColor = .clear
    collectionView.preservesSuperviewLayoutMargins = true
    collectionView.alwaysBounceHorizontal = false
    collectionView.alwaysBounceVertical = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = true
    collectionView.dataSource = self as? UICollectionViewDataSource
    collectionView.delegate = self as? UICollectionViewDelegate
    collectionView.prefetchDataSource = self as? UICollectionViewDataSourcePrefetching
    collectionView.dragDelegate = self as? UICollectionViewDragDelegate
    collectionView.dropDelegate = self as? UICollectionViewDropDelegate
    self.collectionView = collectionView
  }

  open var collectionViewIfLoaded: UICollectionView? {
    return _collectionView
  }

  open func collectionViewDidLoad() {
  }

  open var isCollectionViewLoaded: Bool {
    return _collectionView != nil
  }

  // MARK: View Lifecycle

  open override func loadView() {
    if isCollectionViewRoot {
      view = collectionView
    } else {
      super.loadView()
    }
  }

  open override func viewDidLoad() {
    super.viewDidLoad()

    if !isCollectionViewRoot {
      collectionView.frame = view.bounds
      collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      view.insertSubview(collectionView, at: 0)
    }
  }

  open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    if invalidatesLayoutOnViewWillTransition {
      if #available(iOS 13.0, *), collectionViewLayout is UICollectionViewCompositionalLayout {
        return
      }
      collectionViewLayout.invalidateLayout()
    }
  }
}
