//
//  Bundle+Localization.swift
//
//  Created by Sereivoan Yong on 5/23/20.
//

import Foundation

extension Locale {

  /// The selected locale based on the selected localization of `Bundle.main`. It is useful for formatters.
  public fileprivate(set) static var selected = Locale(localization: Bundle.main.selectedLocalization) {
    didSet {
      let selected = selected
      for (_, handler) in autoupdatingSelectedHandlers {
        handler(selected)
      }
    }
  }

  private static var autoupdatingSelectedHandlers: [UUID: (Locale) -> Void] = [:]

  /// When the `selected` locale changes, it will reflect to the specified object at the specified key path.
  /// This is a workaround since we cannot mimic behavior of `autoupdatingCurrent`.
  ///
  ///     Locale.configureAutoupdatingSelected(to: formatter, at: \.locale)
  @discardableResult
  public static func configureAutoupdatingSelected<T: AnyObject>(to object: T, at keyPath: ReferenceWritableKeyPath<T, Locale>) -> UUID {
    return configureAutoupdatingSelected { [weak object] selected in
      object?[keyPath: keyPath] = selected
    }
  }

  /// When the `selected` locale changes, `handler` will be called.
  /// This is a workaround since we cannot mimic behavior of `autoupdatingCurrent`.
  ///
  ///     Locale.configureAutoupdatingSelected { [weak formatter] locale in
  ///       formatter?.locale = locale
  ///     }
  @discardableResult
  public static func configureAutoupdatingSelected(handler: @escaping (Locale) -> Void) -> UUID {
    let id = UUID()
    handler(selected)
    autoupdatingSelectedHandlers[id] = handler
    return id
  }

  public static func unconfigureAutoupdatingSelected(_ id: UUID) {
    autoupdatingSelectedHandlers[id] = nil
  }
}

extension Bundle {

  public static let selectedLocalizationsUserDefaultsKey = "BundleSelectedLocalizations"

  public static let selectedLocalizationDidChangeNotification = Notification.Name("BundleSelectedLocalizationDidChangeNotification")

  private func setLocalization(_ localization: String, bundleIdentifier: String) {
    let store = UserDefaults.standard
    let selectedLocalizations = (store[Self.selectedLocalizationsUserDefaultsKey] as? NSDictionary ?? [:]).mutableCopy() as! NSMutableDictionary
    selectedLocalizations[bundleIdentifier] = localization
    store[Self.selectedLocalizationsUserDefaultsKey] = selectedLocalizations
    if self == .main {
      store["AppleLanguages"] = [localization]
      Locale.selected = Locale(localization: localization)
    }
    selectedLocalizationBundle = nil
    NotificationCenter.default.post(name: Self.selectedLocalizationDidChangeNotification, object: self)
  }

  /// Default is `preferredLocalizations.first`.
  public var selectedLocalization: String! {
    get {
      guard let bundleIdentifier else { return nil }
      if let selectedLocalization = (UserDefaults.standard[Self.selectedLocalizationsUserDefaultsKey] as? NSDictionary)?[bundleIdentifier] as? String {
        return selectedLocalization
      }
      let localization = preferredLocalizations.first ?? "en"
      setLocalization(localization, bundleIdentifier: bundleIdentifier)
      return localization
    }
    set {
      guard let bundleIdentifier else { return }
      let localization = newValue ?? preferredLocalizations.first ?? "en"
      setLocalization(localization, bundleIdentifier: bundleIdentifier)
    }
  }

  private static var selectedLocalizationBundleKey: Void?
  // Set to nil to force reload
  private var selectedLocalizationBundle: Bundle? {
    get {
      if let bundle = associatedObject(forKey: &Self.selectedLocalizationBundleKey, with: self) as Bundle? {
        return bundle
      }
      if let url = url(forResource: selectedLocalization, withExtension: "lproj"), let bundle = Bundle(url: url) {
        setAssociatedObject(bundle, forKey: &Self.selectedLocalizationBundleKey, with: self)
        return bundle
      }
      return nil
    }
    set {
      setAssociatedObject(newValue, forKey: &Self.selectedLocalizationBundleKey, with: self)
    }
  }

  public static func swizzleForLocalization() {
    class_exchangeInstanceMethodImplementations(self, #selector(localizedString(forKey:value:table:)), #selector(_localizedString(forKey:value:table:)))
  }

  @objc private func _localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
    if let selectedLocalizationBundle {
      return selectedLocalizationBundle.localizedString(forKey: key, value: _localizedString(forKey: key, value: value, table: tableName), table: tableName)
    }
    if let bundleIdentifier, bundleIdentifier.hasSuffix("UIKitCore") {
      return Self.main.localizedString(forKey: key, value: _localizedString(forKey: key, value: value, table: tableName), table: tableName)
    }
    return _localizedString(forKey: key, value: value, table: tableName)
  }
}
