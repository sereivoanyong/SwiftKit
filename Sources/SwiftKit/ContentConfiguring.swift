//
//  ContentConfiguring.swift
//
//  Created by Sereivoan Yong on 2/26/20.
//

import UIKit

public protocol ContentConfiguring<Content> {

  associatedtype Content
  
  func configure(_ content: Content)
}

extension ContentConfiguring where Self: UITableViewCell {

  public static var provider: UITableView.CellProvider<Content> {
    return provider(identifier: String(describing: self))
  }
  
  // `identifier: String = String(describing: self)` would just incorrectly returns "(Function)" instead of class name (Swift protocol's bug?).
  public static func provider(identifier: String) -> UITableView.CellProvider<Content> {
    return { tableView, indexPath, object in
      let cell = tableView.dequeue(self, identifier: identifier, for: indexPath)
      cell.configure(object)
      return cell
    }
  }
}

extension ContentConfiguring where Self: UICollectionViewCell {
  
  public static var provider: UICollectionView.CellProvider<Content> {
    return provider(identifier: String(describing: self))
  }
  
  public static func provider(identifier: String) -> UICollectionView.CellProvider<Content> {
    return { collectionView, indexPath, object in
      let cell = collectionView.dequeue(self, identifier: identifier, for: indexPath)
      cell.configure(object)
      return cell
    }
  }
}
