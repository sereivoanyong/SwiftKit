//
//  Bundle+Localization.swift
//
//  Created by Sereivoan Yong on 5/23/20.
//

import Foundation

extension Locale {

  /// The selected locale based on the selected localization of `Bundle.main`. It is useful for formatters.
  public fileprivate(set) static var selected: Locale! {
    didSet {
      let selected = selected!
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

  public private(set) static var mainLocalized: Bundle!

  public static let selectedLocalizationsUserDefaultsKey = "BundleSelectedLocalizations"

  public private(set) static var selectedLocalizations: [String: String] {
    get { return UserDefaults.standard[Self.selectedLocalizationsUserDefaultsKey] as? [String: String] ?? [:] }
    set { UserDefaults.standard[Self.selectedLocalizationsUserDefaultsKey] = newValue as NSDictionary }
  }

  public static let selectedLocalizationDidChangeNotification = Notification.Name("BundleSelectedLocalizationDidChangeNotification")

  private var preferredLocalization: String {
    for localization in preferredLocalizations {
      if localization == "Base" {
        continue
      }
      return localization
    }
    return "en"
  }

  private static var selectedLocalizationKey: Void?

  public var selectedLocalization: String! {
    get {
      let localization: String?
      if let bundleIdentifier {
        localization = Self.selectedLocalizations[bundleIdentifier]
      } else {
        localization = associatedValue(forKey: &Self.selectedLocalizationKey, with: self)
      }
      if let localization {
        if Locale.selected == nil {
          Locale.selected = Locale(localization: localization)
        }
        return localization
      }
      if self == .main {
        let localization = preferredLocalization
        self.selectedLocalization = localization
        return localization
      } else {
        return nil
      }
    }
    set(localization) {
      if let localization, localizations.contains(localization), let url = url(forResource: localization, withExtension: "lproj"), let bundle = Bundle(url: url) {
        if let bundleIdentifier {
          Self.selectedLocalizations[bundleIdentifier] = localization
        }
        setAssociatedValue(localization, forKey: &Self.selectedLocalizationKey, with: self)
        selectedLocalizationBundle = bundle
        if self == .main {
          UserDefaults.standard["AppleLanguages"] = [localization]
          Locale.selected = Locale(localization: localization)
          Self.mainLocalized = bundle
        }
      } else {
        if let bundleIdentifier {
          Self.selectedLocalizations[bundleIdentifier] = nil
        }
        setAssociatedValue(nil as String?, forKey: &Self.selectedLocalizationKey, with: self)
        selectedLocalizationBundle = nil
        if self == .main {
          UserDefaults.standard["AppleLanguages"] = ["en"]
          Locale.selected = Locale(localization: "en")
          Self.mainLocalized = nil
        }
      }
      NotificationCenter.default.post(name: Self.selectedLocalizationDidChangeNotification, object: self)
    }
  }

  private static var selectedLocalizationBundleKey: Void?

  public private(set) var selectedLocalizationBundle: Bundle? {
    get {
      if let bundle = associatedObject(forKey: &Self.selectedLocalizationBundleKey, with: self) as Bundle? {
        return bundle
      }
      // Try again in case selectedLocalization is not accessed
      _ = selectedLocalization
      return associatedObject(forKey: &Self.selectedLocalizationBundleKey, with: self) as Bundle?
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
