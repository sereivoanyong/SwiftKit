//
//  UIControl.swift
//
//  Created by Sereivoan Yong on 12/1/20.
//

#if canImport(UIKit)
import UIKit

extension UIControl {

  @available(*, deprecated, message: "Use `bc.primaryAction` instead.")
  public var _primaryAction: Action? {
    get { return bc.primaryAction }
    set { bc.primaryAction = newValue }
  }

  private struct Key: Hashable {

    let identifier: Action.Identifier
    let events: Event

    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
      hasher.combine(events.rawValue)
    }
  }

  private static var actionsKey: Void?
  private var actions: [Key: Action] {
    get { return associatedValue(forKey: &Self.actionsKey, default: [:]) }
    set { setAssociatedValue(newValue, forKey: &Self.actionsKey) }
  }

  /// Adds the `action` to given `events`. They are uniqued based on their `identifier`, and subsequent actions with the same `identifier` replace previously added actions. You may add multiple actions for corresponding `events`, and you may add the same action to multiple `events`.
  public func addAction(_ action: Action, for events: Event) {
    var currentActions = actions
    // Check if there is a different action object but with the same identifer
    let hasTheSameIdentifier: (Key) -> Bool = { $0.identifier == action.identifier }
    if let key = currentActions.keys.first(where: hasTheSameIdentifier), action !== currentActions[key] {
      let action = currentActions.removeValue(forKey: key)
      removeTarget(action, action: #selector(Action.invoke(_:)), for: key.events)
      for key in currentActions.keys.filter(hasTheSameIdentifier) {
        let action = currentActions.removeValue(forKey: key)
        removeTarget(action, action: #selector(Action.invoke(_:)), for: key.events)
      }
    }

    let key = Key(identifier: action.identifier, events: events)
    // Ignore if attempting to add the same action and the same events
    if currentActions[key] == nil {
      currentActions[key] = action
      addTarget(action, action: #selector(Action.invoke(_:)), for: events)
    }
    actions = currentActions
  }

  public func addAction(handler: @escaping (Action) -> Void, for events: Event) {
    addAction(Action(handler: handler), for: events)
  }

  /// Removes the `action` from the set of passed `events`.
  public func removeAction(_ action: Action, for events: Event) {
    removeAction(identifier: action.identifier, for: events)
  }

  /// Removes the `action` with the provided `identifier` from the set of passed `events`.
  public func removeAction(identifier: Action.Identifier, for events: Event) {
    let key = Key(identifier: identifier, events: events)
    if let action = actions.removeValue(forKey: key) {
      removeTarget(action, action: #selector(Action.invoke(_:)), for: events)
    }
  }

  @objc(bc_initWithFrame:primaryAction:)
  public convenience init(frame: CGRect, primaryAction: Action?) {
    self.init(frame: frame)
    bc.primaryAction = primaryAction
  }

  @objc func bc_setPrimaryAction(_ primaryAction: Action?) {

  }
}

private var primaryActionKey: Void?
extension BackwardCompatibility where Base: UIControl {

  public var primaryAction: Action? {
    get { return base.associatedObject(forKey: &primaryActionKey) }
    nonmutating set {
      let oldValue = primaryAction
      guard newValue !== oldValue else {
        return
      }
      if let oldValue {
        base.removeTarget(oldValue, action: #selector(Action.invoke(_:)), for: .primaryActionTriggered)
      }
      if let newValue {
        base.addTarget(newValue, action: #selector(Action.invoke(_:)), for: .primaryActionTriggered)
      }
      base.setAssociatedObject(newValue, forKey: &primaryActionKey)
      base.bc_setPrimaryAction(newValue)
    }
  }
}

extension UIControl: BackwardCompatible { }
#endif
