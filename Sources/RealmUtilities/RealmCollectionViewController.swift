//
//  RealmCollectionViewController.swift
//
//  Created by Sereivoan Yong on 11/14/23.
//

import UIKitUtilities
import RealmSwift

open class RealmCollectionViewController<Object: ObjectBase & RealmCollectionValue>: CollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate, EmptyViewStateProviding, EmptyViewDataSource {

  private var objectsNotificationToken: NotificationToken?

  public let initialObjects: AnyRealmCollection<Object>

  open private(set) var objects: AnyRealmCollection<Object> {
    didSet {
      if isCollectionViewLoaded {
        observeObjects()
        collectionView.reloadData()
        objectsDidChange()
      }
    }
  }

  open var sectionForObjects: Int {
    return 0
  }

  // MARK: Init / Deinit
  public init<C: RealmCollection & _ObjcBridgeable>(objects: C) where C.Element == Object {
    let objects = objects as? AnyRealmCollection<Object> ?? .init(objects)
    self.initialObjects = objects
    self.objects = objects
    super.init(nibName: nil, bundle: nil)

    self.title = Object.className()
    self.objects = updateObjects(initial: initialObjects)
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Collection View Lifecycle

  open override func collectionViewDidLoad() {
    super.collectionViewDidLoad()

    let emptyView = EmptyView()
    emptyView.stateProvider = self
    emptyView.dataSource = self
    collectionView.emptyView = emptyView

    observeObjects()
    collectionView.reloadData()
    objectsDidChange()
  }

  // MARK: Objects

  open func observeObjects() {
    objectsNotificationToken = objects.observe(on: .main) { [unowned self] change in
      switch change {
      case .initial:
        reloadCollectionViewDataForInitialChange()
        objectsDidChange()

      case .update(_, let deletions, let insertions, let modifications):
        updateCollectionViewDataForUpdateChange(deletions: deletions, insertions: insertions, modifications: modifications)
        objectsDidChange()

      case .error(let error):
        print(error)
      }
    }
  }

  /// Call in `.initial(_:)` and `didSet` of `objects`
  open func reloadCollectionViewDataForInitialChange() {
    collectionView.reloadData()
  }

  /// Call in `.update(_:deletions:insertions:modifications)`
  open func updateCollectionViewDataForUpdateChange(deletions: [Int], insertions: [Int], modifications: [Int]) {
    let section = sectionForObjects
    collectionView.performBatchUpdates({ [unowned self] in
      collectionView.deleteItems(at: deletions.map { IndexPath(item: $0, section: section) })
      collectionView.insertItems(at: insertions.map { IndexPath(item: $0, section: section) })
      collectionView.reloadItems(at: modifications.map { IndexPath(item: $0, section: section) })
    }, completion: nil)
  }

  /// Always called in pair after `initial` or `update`
  /// `reloadCollectionViewDataForInitialChange()`
  /// `updateCollectionViewInBatchForUpdateChange(_:deletions:insertions:modifications:)`
  open func objectsDidChange() {
  }

  open func setNeedsObjectsUpdate() {
    objects = updateObjects(initial: initialObjects)
  }

  open func updateObjects<C: RealmCollection & _ObjcBridgeable>(initial objects: C) -> AnyRealmCollection<Object> where C.Element == Object {
    return objects as? AnyRealmCollection<Object> ?? .init(objects)
  }

  // MARK: Data

  open func isSectionForObjects(section: Int) -> Bool {
    return section == sectionForObjects
  }

  open func numberOfObjects(section: Int) -> Int {
    return objects.count
  }

  open func object(at indexPath: IndexPath) -> Object {
    assert(isSectionForObjects(section: indexPath.section))
    return objects[indexPath.item]
  }

  // MARK: UICollectionViewDataSource

  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard isSectionForObjects(section: section) else {
      fatalError()
    }
    return numberOfObjects(section: section)
  }

  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard isSectionForObjects(section: indexPath.section) else {
      fatalError()
    }
    return self.collectionView(collectionView, cellForItemAt: indexPath, with: object(at: indexPath))
  }

  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, with object: Object) -> UICollectionViewCell {
    fatalError()
  }

  // MARK: UICollectionViewDelegate

  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard isSectionForObjects(section: indexPath.section) else {
      return
    }
    self.collectionView(collectionView, didSelectItemAt: indexPath, with: object(at: indexPath))
  }

  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, with object: Object) {
  }

  // MARK: EmptyViewStateProviding

  open func state(for emptyView: EmptyView) -> EmptyView.State? {
    if objects.isEmpty {
      return .empty
    }
    return nil
  }

  // MARK: EmptyViewDataSource

  open func emptyView(_ emptyView: EmptyView, configureContentFor state: EmptyView.State) {
    switch state {
    case .empty:
      emptyView.title = "No Data"
    case .error(let error):
      print(error)
    }
  }
}
