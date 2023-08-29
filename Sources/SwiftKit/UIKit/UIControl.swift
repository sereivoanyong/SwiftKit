//
//  UIControl.swift
//
//  Created by Sereivoan Yong on 12/1/20.
//

import UIKit

extension UIControl {

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
    get { return associatedValue(default: [:], forKey: &Self.actionsKey, with: self) }
    set { setAssociatedValue(newValue, forKey: &Self.actionsKey, with: self) }
  }

  /// Adds the `action` to given `events`. They are uniqued based on their `identifier`, and subsequent actions with the same `identifier` replace previously added actions. You may add multiple actions for corresponding `events`, and you may add the same action to multiple `events`.
  public func addAction(_ action: Action, for events: Event) {
    let key = Key(identifier: action.identifier, events: events)
    var actions = actions

    // Check if the action already exists
    if actions[key] === action {
      return
    }

    // Removing existing actions with the same identifer
    for (existingKey, existingAction) in actions where existingAction.identifier == action.identifier {
      actions[existingKey] = nil
      removeTarget(existingAction, action: #selector(Action.performAction(_:)), for: existingKey.events)
    }

    actions[key] = action
    addTarget(action, action: #selector(Action.performAction(_:)), for: events)
    self.actions = actions
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
      removeTarget(action, action: #selector(Action.performAction(_:)), for: events)
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
    get { return associatedObject(forKey: &primaryActionKey, with: base) }
    nonmutating set {
      let oldValue = primaryAction
      guard newValue !== oldValue else {
        return
      }
      if let oldValue {
        base.removeTarget(oldValue, action: #selector(Action.performAction(_:)), for: .primaryActionTriggered)
      }
      if let newValue {
        base.addTarget(newValue, action: #selector(Action.performAction(_:)), for: .primaryActionTriggered)
      }
      setAssociatedObject(newValue, forKey: &primaryActionKey, with: base)
      base.bc_setPrimaryAction(newValue)
    }
  }
}

extension UIControl: BackwardCompatible { }
