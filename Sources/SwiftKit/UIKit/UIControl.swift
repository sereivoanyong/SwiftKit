//
//  UIControl.swift
//
//  Created by Sereivoan Yong on 12/1/20.
//

#if canImport(UIKit)
import UIKit

extension UIControl {
  
  private struct Key: Hashable {
    
    let identifier: UUID
    let events: Event
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
      hasher.combine(events.rawValue)
    }
  }
  
  private static var actionsKey: Void?
  private var actions: [Key: Action<UIControl>] {
    get { associatedValue(forKey: &Self.actionsKey, default: [:]) }
    set { setAssociatedValue(newValue, forKey: &Self.actionsKey) }
  }
  
  /// Adds the `action` to given `events`. They are uniqued based on their `identifier`, and subsequent actions with the same `identifier` replace previously added actions. You may add multiple actions for corresponding `events`, and you may add the same action to multiple `events`.
  final public func addAction(_ action: Action<UIControl>, for events: Event) {
    var currentActions = actions
    // Check if there is a different action object but with the same identifer
    let hasTheSameIdentifier: (Key) -> Bool = { $0.identifier == action.identifier }
    if let key = currentActions.keys.first(where: hasTheSameIdentifier), action !== currentActions[key] {
      let action = currentActions.removeValue(forKey: key)
      removeTarget(action, action: #selector(Action<UIControl>.invoke(_:)), for: key.events)
      for key in currentActions.keys.filter(hasTheSameIdentifier) {
        let action = currentActions.removeValue(forKey: key)
        removeTarget(action, action: #selector(Action<UIControl>.invoke(_:)), for: key.events)
      }
    }
    
    let key = Key(identifier: action.identifier, events: events)
    // Ignore if attempting to add the same action and the same events
    if currentActions[key] == nil {
      currentActions[key] = action
      addTarget(action, action: #selector(Action<UIControl>.invoke(_:)), for: events)
    }
    actions = currentActions
  }

  final public func addAction(handler: @escaping (Action<UIControl>) -> Void, for events: Event) {
    addAction(Action<UIControl>(handler: handler), for: events)
  }
  
  /// Removes the `action` from the set of passed `events`.
  final public func removeAction(_ action: Action<UIControl>, for events: Event) {
    removeAction(identifier: action.identifier, for: events)
  }
  
  /// Removes the `action` with the provided `identifier` from the set of passed `events`.
  final public func removeAction(identifier: Action<UIControl>.Identifier, for events: Event) {
    let key = Key(identifier: identifier, events: events)
    if let action = actions.removeValue(forKey: key) {
      removeTarget(action, action: #selector(Action<UIControl>.invoke(_:)), for: events)
    }
  }
}
#endif