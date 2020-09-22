//
//  Bundle+Localization.swift
//
//  Created by Sereivoan Yong on 5/23/20.
//

import Foundation

extension Locale {
  
  public fileprivate(set) static var selected = Locale(identifier: Bundle.selectedLocalization) {
    didSet {
      changeHandler?(selected)
    }
  }
  public static var changeHandler: ((Locale) -> Void)?
}

extension Bundle {
  
  public static let selectedLocalizationDidChangeNotification = Notification.Name("BundleSelectedLocalizationDidChangeNotification")
  
  public static var selectedLocalization: String = {
    if let selectedLocalization = UserDefaults.standard.string(forKey: "SelectedLocalization"), main.preferredLocalizations.first == selectedLocalization {
      return selectedLocalization
    }
    for preferredLocalization in main.preferredLocalizations {
      UserDefaults.standard.set([preferredLocalization], forKey: "AppleLanguages")
      UserDefaults.standard.set(preferredLocalization, forKey: "SelectedLocalization")
      return preferredLocalization
    }
    fatalError()
  }() {
    didSet {
      assert(main.localizations.contains(selectedLocalization))
      guard let path = main.path(forResource: selectedLocalization, ofType: "lproj"), let bundle = Bundle(path: path) else {
        selected = main
        NotificationCenter.default.post(name: Self.selectedLocalizationDidChangeNotification, object: main)
        return
      }
      selected = bundle
      Locale.selected = Locale(identifier: Bundle.selectedLocalization)
      UserDefaults.standard.set([selectedLocalization], forKey: "AppleLanguages")
      UserDefaults.standard.set(selectedLocalization, forKey: "SelectedLocalization")
      NotificationCenter.default.post(name: Self.selectedLocalizationDidChangeNotification, object: main)
    }
  }
  
  private static var selected: Bundle = main.path(forResource: selectedLocalization, ofType: "lproj").flatMap(Bundle.init(path:)) ?? main
  
  public static func swizzleForLocalization() {
    class_exchangeInstanceMethodImplementations(self, #selector(localizedString(forKey:value:table:)), #selector(_localizedString(forKey:value:table:)))
  }
  
  @objc private func _localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
    if self == .main {
      return Self.selected.localizedString(forKey: key, value: _localizedString(forKey: key, value: value, table: tableName), table: tableName)
    }
    if let bundleIdentifier = bundleIdentifier, bundleIdentifier.hasSuffix("UIKitCore") {
      return Self.selected.localizedString(forKey: key, value: _localizedString(forKey: key, value: value, table: tableName), table: tableName)
    }
    return _localizedString(forKey: key, value: value, table: tableName)
  }
}
