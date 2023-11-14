//
//  RealmSectionedResultsViewController.swift
//
//  Created by Sereivoan Yong on 11/14/23.
//

import UIKitUtilities
import RealmSwift

open class RealmSectionedResultsViewController<Key: _Persistable & Hashable, Object: ObjectBase & RealmCollectionValue>: CollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate, EmptyViewStateProviding, EmptyViewDataSource {

  private var resultsNotificationToken: NotificationToken?

  public let initialObjects: AnyRealmCollection<Object>

  open private(set) var results: SectionedResults<Key, Object>! {
    didSet {
      if isCollectionViewLoaded {
        observeResults()
        reloadCollectionViewDataForInitialChange()
        resultsDidChange()
      }
    }
  }

  // MARK: Init / Deinit
  public init<C: RealmCollection & _ObjcBridgeable>(objects: C) where C.Element == Object {
    let objects = objects as? AnyRealmCollection<Object> ?? .init(objects)
    self.initialObjects = objects
    super.init(nibName: nil, bundle: nil)

    self.title = Object.className()
    self.results = updateResults(initial: initialObjects)
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

    observeResults()
  }

  // MARK: Results

  open func observeResults() {
    resultsNotificationToken = results.observe(on: .main) { [unowned self] change in
      switch change {
      case .initial:
        reloadCollectionViewDataForInitialChange()
        resultsDidChange()

      case .update(_, let deletions, let insertions, let modifications, let sectionsToInsert, let sectionsToDelete):
        updateCollectionViewDataForUpdateChange(deletions: deletions, insertions: insertions, modifications: modifications, sectionsToInsert: sectionsToInsert, sectionsToDelete: sectionsToDelete)
        resultsDidChange()
      }
    }
  }

  /// Call in `.initial(_:)` and `didSet` of `results`
  open func reloadCollectionViewDataForInitialChange() {
    guard isCollectionViewLoaded else {
      return
    }
    collectionView.reloadData()
  }

  /// Call in `.update(_:deletions:insertions:modifications)`
  open func updateCollectionViewDataForUpdateChange(deletions: [IndexPath], insertions: [IndexPath], modifications: [IndexPath], sectionsToInsert: IndexSet, sectionsToDelete: IndexSet) {
    collectionView.performBatchUpdates({ [unowned self] in
      collectionView.deleteItems(at: deletions)
      collectionView.insertItems(at: insertions)
      collectionView.reloadItems(at: modifications)
      collectionView.insertSections(sectionsToInsert)
      collectionView.deleteSections(sectionsToDelete)
    }, completion: nil)
  }

  /// Always called in pair after `initial` or `update`
  /// `reloadCollectionViewDataForInitialChange()`
  /// `updateCollectionViewInBatchForUpdateChange(_:deletions:insertions:modifications:sectionsToInsert:sectionsToDelete:)`
  open func resultsDidChange() {
  }

  open func setNeedsResultsUpdate() {
    results = updateResults(initial: initialObjects)
  }

  open func updateResults<C: RealmCollection & _ObjcBridgeable>(initial objects: C) -> SectionedResults<Key, Object> where C.Element == Object {
    fatalError()
  }

  // MARK: Data

  open func object(at indexPath: IndexPath) -> Object {
    return results[indexPath]
  }

  // MARK: UICollectionViewDataSource

  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return results.count
  }

  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return results[section].count
  }

  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return self.collectionView(collectionView, cellForItemAt: indexPath, with: object(at: indexPath))
  }

  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, with object: Object) -> UICollectionViewCell {
    fatalError()
  }

  // MARK: UICollectionViewDelegate

  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.collectionView(collectionView, didSelectItemAt: indexPath, with: object(at: indexPath))
  }

  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, with object: Object) {
  }

  // MARK: EmptyViewStateProviding

  open func state(for emptyView: EmptyView) -> EmptyView.State? {
    if results.isEmpty {
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
