//
//  CollectionViewController.swift
//
//  Created by Sereivoan Yong on 3/5/21.
//

import UIKit

open class CollectionViewController: UIViewController {

  open class var collectionViewClass: UICollectionView.Type {
    return UICollectionView.self
  }

  open var invalidatesLayoutOnViewWillTransition: Bool = true

  open private(set) var collectionViewIfLoaded: UICollectionView?

  @IBOutlet weak open var collectionView: UICollectionView! {
    get {
      if let collectionViewIfLoaded {
        return collectionViewIfLoaded
      }
      loadCollectionView()
      return collectionViewIfLoaded
    }
    set {
      precondition(collectionViewIfLoaded == nil, "Collection view can only be set before it is loaded.")
      collectionViewIfLoaded = newValue
      collectionViewDidLoad()
    }
  }

  open private(set) var collectionViewLayoutIfLoaded: UICollectionViewLayout?
  open var collectionViewLayout: UICollectionViewLayout {
    if let collectionViewLayoutIfLoaded {
      return collectionViewLayoutIfLoaded
    }
    let collectionViewLayout: UICollectionViewLayout
    if let collectionViewIfLoaded {
      collectionViewLayout = collectionViewIfLoaded.collectionViewLayout
    } else {
      collectionViewLayout = makeCollectionViewLayout()
    }
    collectionViewLayoutIfLoaded = collectionViewLayout
    return collectionViewLayout
  }

  // MARK: Collection View Lifecycle

  open func makeCollectionViewLayout() -> UICollectionViewLayout {
    fatalError("\(#function) has not been implemented")
  }

  open func loadCollectionView() {
    let collectionView = Self.collectionViewClass.init(frame: UIScreen.main.bounds, collectionViewLayout: collectionViewLayout)
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

  open func collectionViewDidLoad() {
  }

  open var isCollectionViewLoaded: Bool {
    return collectionViewIfLoaded != nil
  }

  // MARK: View Lifecycle

  open override func viewDidLoad() {
    super.viewDidLoad()

    if collectionView.superview == nil {
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
