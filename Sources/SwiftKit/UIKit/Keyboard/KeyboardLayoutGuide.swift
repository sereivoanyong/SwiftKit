//
//  KeyboardLayoutGuide.swift
//
//  Created by Sereivoan Yong on 1/14/24.
//

import UIKit

final public class KeyboardLayoutGuide: UILayoutGuide {

  /// A Boolean value that indicates whether the layout guide uses the view’s safe area layout guide.
  ///
  /// Defaults to `true`, indicating that the layout guide ties to the `bottomAnchor` of the view’s `safeAreaLayoutGuide`.
  /// Set to `false` to tie the layout guide to the `bottomAnchor` of the view instead.
  public var usesSafeArea: Bool = true
}
