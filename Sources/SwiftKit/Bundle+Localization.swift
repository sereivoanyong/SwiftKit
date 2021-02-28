//
//  Bundle+Localization.swift
//
//  Created by Sereivoan Yong on 5/23/20.
//

import Foundation

extension Locale {
  
  public fileprivate(set) static var selected = Locale(identifier: Bundle.main.selectedLocalization) {
    didSet {
      changeHandler?(selected)
    }
  }
  public static var changeHandler: ((Locale) -> Void)?
}

extension Bundle {
  
  public static let selectedLocalizationDidChangeNotification = Notification.Name("BundleSelectedLocalizationDidChangeNotification")
  
  public var selectedLocalization: String! {
    get {
      guard let bundleIdentifier = bundleIdentifier else {
        preconditionFailure()
      }
      if let selectedLocalization = UserDefaults.standard.string(forKey: "\(bundleIdentifier).SelectedLocalization"), preferredLocalizations.first == selectedLocalization {
        return selectedLocalization
      }
      for localization in preferredLocalizations {
        UserDefaults.standard.appleLanguages = [localization]
        UserDefaults.standard.set(localization, forKey: "\(bundleIdentifier).SelectedLocalization")
        return localization
      }
      return nil
    }
    set(newLocalization) {
      guard let bundleIdentifier = bundleIdentifier else {
        preconditionFailure()
      }
      assert(localizations.contains(newLocalization))
      guard let path = path(forResource: newLocalization, ofType: "lproj"), let bundle = Bundle(path: path) else {
        selectedLocalizationBundle = nil
        NotificationCenter.default.post(name: Self.selectedLocalizationDidChangeNotification, object: self)
        return
      }
      selectedLocalizationBundle = bundle
      if self == .main {
        Locale.selected = Locale(identifier: selectedLocalization)
      }
      UserDefaults.standard.appleLanguages = [selectedLocalization]
      UserDefaults.standard.set(selectedLocalization, forKey: "\(bundleIdentifier).SelectedLocalization")
      NotificationCenter.default.post(name: Self.selectedLocalizationDidChangeNotification, object: self)
    }
  }

  private static var selectedLocalizationBundleKey: Void?
  private var selectedLocalizationBundle: Bundle? {
    get {
      if let bundle = associatedObject(forKey: &Self.selectedLocalizationBundleKey) as Bundle? {
        return bundle
      }
      if let bundle = path(forResource: selectedLocalization, ofType: "lproj").flatMap(Bundle.init(path:)) {
        setAssociatedObject(bundle, forKey: &Self.selectedLocalizationBundleKey)
        return bundle
      }
      return nil
    }
    set {
      setAssociatedObject(newValue, forKey: &Self.selectedLocalizationBundleKey)
    }
  }
  
  public static func swizzleForLocalization() {
    class_exchangeInstanceMethodImplementations(self, #selector(localizedString(forKey:value:table:)), #selector(_localizedString(forKey:value:table:)))
  }
  
  @objc private func _localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
    if let selectedLocalizationBundle = selectedLocalizationBundle {
      return selectedLocalizationBundle.localizedString(forKey: key, value: _localizedString(forKey: key, value: value, table: tableName), table: tableName)
    }
    if let bundleIdentifier = bundleIdentifier, bundleIdentifier.hasSuffix("UIKitCore") {
      return Self.main.localizedString(forKey: key, value: _localizedString(forKey: key, value: value, table: tableName), table: tableName)
    }
    return _localizedString(forKey: key, value: value, table: tableName)
  }
}
