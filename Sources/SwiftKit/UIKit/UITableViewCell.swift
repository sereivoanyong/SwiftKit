//
//  UITableViewCell.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)
import UIKit

extension UITableViewCell {

  public var style: CellStyle {
    return CellStyle(rawValue: value(forKey: "style") as! Int)!
  }

  public var _accessoryView: UIControl? { // For top-most cell in grouped table view.
    return value(forKey: "_accessoryView") as? UIControl
  }

  public var _accessoryTintColor: UIColor? {
    get { return value(forKey: "_accessoryTintColor") as? UIColor }
    set { setValue(newValue, forKey: "_accessoryTintColor") }
  }

  @available(iOS 7.0, *)
  public var topSeparatorView: UIView? { // For top-most cell in grouped table view.
    return value(forKey: "_topSeparatorView") as? UIView
  }

  public var separatorView: UIView? {
    return value(forKey: "_separatorView") as? UIView
  }

  public var separatorColor: UIColor? {
    get { return value(forKey: "separatorColor") as? UIColor }
    set { setValue(newValue, forKey: "separatorColor") }
  }

  @available(iOS 7.0, *)
  public var isSeparatorHidden: Bool {
    get { return performIfResponds(Selector(("_separatorHidden")))?.takeUnretainedValue() as? Bool ?? false }
    set { performIfResponds(Selector(("_setSeparatorHidden:")), with: newValue as NSNumber) }
  }

  public var selectedBackgroundColor: UIColor? {
    get {
      return selectedBackgroundView?.backgroundColor
    }
    set {
      guard let color = newValue else {
        if let selectedBackgroundView = selectedBackgroundView, type(of: selectedBackgroundView) == UIView.self {
          selectedBackgroundView.backgroundColor = nil
        } else {
          selectedBackgroundView = nil
        }
        return
      }
      if let selectedBackgroundView = selectedBackgroundView, type(of: selectedBackgroundView) == UIView.self {
        selectedBackgroundView.backgroundColor = color
      } else {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = color
        self.selectedBackgroundView = selectedBackgroundView
      }
    }
  }

  /// Returns a flag indicating whether the cell is visible in specified table view.
  public func isVisible(in tableView: UITableView) -> Bool {
    let rect = tableView.convert(frame, to: tableView.superview)
    return tableView.frame.contains(rect)
  }

  public func _disclosureChevronImage(_ arg1: Bool) -> UIImage? {
    return perform(Selector(("_disclosureChevronImage:")), with: arg1 as NSNumber)?.takeUnretainedValue() as? UIImage
  }

  public func _tintedDisclosureImagePressed(_ arg1: Bool) -> UIImage? {
    return perform(Selector(("_tintedDisclosureImagePressed:")), with: arg1 as NSNumber)?.takeUnretainedValue() as? UIImage
  }

  public func _detailDisclosureImage(_ arg1: Bool) -> UIImage? {
    return perform(Selector(("_detailDisclosureImage:")), with: arg1 as NSNumber)?.takeUnretainedValue() as? UIImage
  }

  public func _checkmarkImage(_ arg1: Bool) -> UIImage? {
    return perform(Selector(("_checkmarkImage:")), with: arg1 as NSNumber)?.takeUnretainedValue() as? UIImage
  }
}
#endif
