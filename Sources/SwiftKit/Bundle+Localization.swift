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

  public static let selectedLocalizationUserDefaultsKey = "SelectedLocalization"

  public static let selectedLocalizationDidChangeNotification = Notification.Name("BundleSelectedLocalizationDidChangeNotification")

  /// Default is `preferredLocalizations.first`.
  public var selectedLocalization: String! {
    get {
      if let selectedLocalization = UserDefaults.standard.string(forKey: Self.selectedLocalizationUserDefaultsKey) {
        return selectedLocalization
      }
      for localization in preferredLocalizations {
        UserDefaults.standard.appleLanguages = [localization]
        UserDefaults.standard.set(localization, forKey: Self.selectedLocalizationUserDefaultsKey)
        selectedLocalizationBundle = nil
        return localization
      }
      return nil
    }
    set(newLocalization) {
      let newLocalization = newLocalization ?? preferredLocalizations.first!
      UserDefaults.standard.appleLanguages = [newLocalization]
      UserDefaults.standard.set(newLocalization, forKey: Self.selectedLocalizationUserDefaultsKey)
      selectedLocalizationBundle = nil
      if self == .main {
        Locale.selected = Locale(identifier: newLocalization)
      }
      NotificationCenter.default.post(name: Self.selectedLocalizationDidChangeNotification, object: self)
    }
  }

  private static var selectedLocalizationBundleKey: Void?
  // Set to nil to force reload
  private var selectedLocalizationBundle: Bundle? {
    get {
      if let bundle = associatedObject(forKey: &Self.selectedLocalizationBundleKey) as Bundle? {
        return bundle
      }
      if let bundle = url(forResource: selectedLocalization, withExtension: "lproj").flatMap(Bundle.init(url:)) {
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
