//
//  ListContentView.swift
//
//  Created by Sereivoan Yong on 9/19/22.
//

import UIKit

@available(iOS 14.0, *)
public protocol ListContentView: UIView, UIContentView {

  var primaryContentAnchorsForSeparator: (leading: NSLayoutXAxisAnchor, trailing: NSLayoutXAxisAnchor) { get }
}
