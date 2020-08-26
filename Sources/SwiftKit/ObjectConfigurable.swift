//
//  ObjectConfigurable.swift
//
//  Created by Sereivoan Yong on 2/26/20.
//

public protocol ObjectConfigurable {
  
  associatedtype Object
  
  func configure(_ object: Object)
}

#if canImport(UIKit)
import UIKit

extension ObjectConfigurable where Self: UITableViewCell {
  
  public static var provider: UITableView.CellProvider<Object> {
    return provider(identifier: String(describing: self))
  }
  
  // `identifier: String = String(describing: self)` would just incorrectly returns "(Function)" instead of class name (Swift protocol's bug?).
  public static func provider(identifier: String) -> UITableView.CellProvider<Object> {
    return { tableView, indexPath, object in
      let cell = tableView.dequeue(self, identifier: identifier, for: indexPath)
      cell.configure(object)
      return cell
    }
  }
}

extension ObjectConfigurable where Self: UICollectionViewCell {
  
  public static var provider: UICollectionView.CellProvider<Object> {
    return provider(identifier: String(describing: self))
  }
  
  public static func provider(identifier: String) -> UICollectionView.CellProvider<Object> {
    return { collectionView, indexPath, object in
      let cell = collectionView.dequeue(self, identifier: identifier, for: indexPath)
      cell.configure(object)
      return cell
    }
  }
}
#endif
