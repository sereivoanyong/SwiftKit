//
//  FilterItemView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 4/15/25.
//

import UIKit
import SwiftKit
import Combine

@available(iOS 15.0, *)
final class FilterItemView: UIView, UIContentView {

  private static var chevronDownImage: UIImage? {
    return UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(font: nameFont, scale: .medium))
  }

  static let baseButtonConfiguration: UIButton.Configuration = {
    var configuration: UIButton.Configuration
    if #available(iOS 26.0, *) {
      configuration = .glass()
      configuration.cornerStyle = .capsule
    } else {
      configuration = .tinted()
      configuration.baseForegroundColor = .label
      configuration.baseBackgroundColor = .clear
      configuration.background.visualEffect = UIBlurEffect(style: .systemMaterial)
      configuration.cornerStyle = .fixed
      configuration.background.cornerRadius = 10
    }
    configuration.buttonSize = .mini
    configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: nameFont, scale: .medium)
    configuration.imagePadding = 2
    configuration.imagePlacement = .trailing
    return configuration
  }()

  static var nameFont: UIFont {
    return .systemFont(ofSize: 12, weight: .medium)
  }

  private var toggleIsSelectedCancellable: AnyCancellable?
  private let toggleActionIdentifier = UIAction.Identifier("ToggleAction")

  var buttonConfiguration: UIButton.Configuration {
    didSet {
      button.configuration = buttonConfiguration
    }
  }

  let button: UIButton

  private var _configuration: FilterItemContentConfiguration

  var configuration: any UIContentConfiguration {
    get { return _configuration }
    set {
      if let newValue = newValue as? FilterItemContentConfiguration {
        _configuration = newValue
        reloadData()
      } else {
        assertionFailure()
      }
    }
  }

  fileprivate var filterView: FilterView? {
    var superview = superview
    while let targetSuperview = superview {
      if let filterView = targetSuperview as? FilterView {
        return filterView
      }
      superview = targetSuperview.superview
    }
    return nil
  }

  init(configuration: FilterItemContentConfiguration) {
    buttonConfiguration = Self.baseButtonConfiguration
    button = UIButton(configuration: buttonConfiguration)
    _configuration = configuration
    super.init(frame: .zero)

    button.configurationUpdateHandler = { [unowned self] button in
      var configuration = buttonConfiguration
      if button.isSelected {
        if #available(iOS 26.0, *) {
          switch _configuration.item.configuration {
          case .toggle:
            break
          case .selection:
            // imageColorTransformer doesn't work on iOS 26 glass. So we reset to the original version after tinting manually.
            configuration.image = Self.chevronDownImage
          }
        } else {
          configuration.baseForegroundColor = .white
          configuration.baseBackgroundColor = nil
        }
        configuration.imageColorTransformer = .init { _ in .tertiaryLabel.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark)) }
      } else {
        if #available(iOS 26.0, *) {
          switch _configuration.item.configuration {
          case .toggle:
            break
          case .selection:
            // baseForegroundColor & imageColorTransformer don't work on iOS 26 glass. So we tint manually.
            configuration.image = Self.chevronDownImage?.withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal)
          }
        } else {
          configuration.baseForegroundColor = .label
          configuration.baseBackgroundColor = .clear
        }
        configuration.imageColorTransformer = .init { _ in .tertiaryLabel }
      }
      buttonConfiguration = configuration
    }

    reloadData()
    addSubview(button)

    button.translatesAutoresizingMaskIntoConstraints = false
    button.directionalAnchors.constraints(equalTo: directionalAnchors).activate()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func reloadData() {
    let item = _configuration.item
    switch item.configuration {
    case .toggle(let buttonHandler):
      let item = item as! any ToggleFilterItemProtocol
      toggleIsSelectedCancellable = item.isSelectedPublisher
        .sink { [unowned self] isSelected in
          button.isSelected = isSelected
        }
      buttonHandler?(button)
      button.showsMenuAsPrimaryAction = false
      button.menu = nil
      button.addAction(UIAction(title: item.currentTitle, identifier: toggleActionIdentifier) { [unowned self] _ in
        let item = _configuration.item as! any ToggleFilterItemProtocol
        let filterView = filterView
        filterView?.unsubscribe()
        item.isSelected.toggle()
        if item.isSelected, let group = item.group {
          for _item in group.filterItems where _item !== item && _item.isSelected {
            _item.isSelected = false
          }
        }
        filterView?.subscribe()
        filterView?.collectionViewLayout.invalidateLayout()
      }, for: .primaryActionTriggered)

    case .selection(let buttonHandler, let valuesProvider, let actionConfigurationProvider, let isEqual):
      toggleIsSelectedCancellable = nil
      buttonHandler?(button)
      button.removeAction(identifiedBy: toggleActionIdentifier, for: .primaryActionTriggered)
      button.showsMenuAsPrimaryAction = true
      button.menu = UIMenu(children: [UIDeferredMenuElement.uncached { [unowned self] actionsProvider in
        valuesProvider({ [unowned self] values in
          let item = _configuration.item as! any SelectionFilterItem
          let isSelected: (Any) -> Bool
          switch item.selectionType {
          case .multi:
            let item = _configuration.item as! any MultiSelectionFilterItemProtocol
            let selectedValues = item.anySelectedValues
            isSelected = { value in
              for selectedValue in selectedValues {
                if isEqual(value, selectedValue) {
                  return true
                }
              }
              return false
            }
          case .single:
            let item = _configuration.item as! any SingleSelectionFilterItemProtocol
            let selectedValue = item.anySelectedValue
            isSelected = { value in
              if let selectedValue {
                return isEqual(value, selectedValue)
              } else {
                return false
              }
            }
          }
          actionsProvider(values.map { value in
            let actionConfiguration = actionConfigurationProvider(value)
            let actionState: UIMenuElement.State = isSelected(value) ? .on : .off
            return UIAction(configuration: actionConfiguration, attributes: [], state: actionState) { [unowned self] action in
              let item = _configuration.item as! any SelectionFilterItem
              var isSelectionChanged: Bool = false
              switch item.selectionType {
              case .multi:
                let item = item as! any MultiSelectionFilterItemProtocol
                if let indexToRemove = item.anySelectedValues.firstIndex(where: { isEqual(value, $0) }) {
                  if item.canDeselect {
                    item.anySelectedValues.remove(at: indexToRemove)
                    isSelectionChanged = true
                  }
                } else {
                  item.anySelectedValues.append(value)
                  isSelectionChanged = true
                }
              case .single:
                let item = item as! any SingleSelectionFilterItemProtocol
                if let anySelectedValue = item.anySelectedValue, isEqual(value, anySelectedValue) {
                  if item.canDeselect {
                    item.anySelectedValue = nil
                    isSelectionChanged = true
                  }
                } else {
                  item.anySelectedValue = value
                  isSelectionChanged = true
                }
              }
              if isSelectionChanged {
                buttonConfiguration.attributedTitle = AttributedString(item.currentTitle, attributes: .init()
                  .font(Self.nameFont)
                )
                button.isSelected = item.isSelected
                filterView?.collectionViewLayout.invalidateLayout()
              }
            }
          })
        })
      }])
    }

    var newButtonConfiguration = buttonConfiguration
    newButtonConfiguration.attributedTitle = AttributedString(item.currentTitle, attributes: .init()
      .font(Self.nameFont)
    )
    switch item.configuration {
    case .toggle:
      newButtonConfiguration.image = nil
    case .selection:
      if #available(iOS 26.0, *), !item.isSelected {
        // imageColorTransformer doesn't work on iOS 26 glass. So we tint manually.
        newButtonConfiguration.image = Self.chevronDownImage?.withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal)
      } else {
        newButtonConfiguration.image = Self.chevronDownImage
      }
    }
    buttonConfiguration = newButtonConfiguration
    button.isSelected = item.isSelected
  }

  static func size(for item: any FilterItem, traitCollection: UITraitCollection) -> CGSize {
    let displayScale = traitCollection.nonZeroDisplayScale
    let titleSize = (item.currentTitle as NSString).size(withAttributes: [.font: nameFont])
    var width = titleSize.width.ceiledToPixel(scale: displayScale)
    switch item.configuration {
    case .toggle:
      break
    case .selection:
      if let image = Self.chevronDownImage {
        width += image.size.width.ceiledToPixel(scale: displayScale) + baseButtonConfiguration.imagePadding
      }
    }
    let height = titleSize.height.ceiledToPixel(scale: displayScale)
    return CGSize(
      width: width + baseButtonConfiguration.contentInsets.horizontal,
      height: height + baseButtonConfiguration.contentInsets.vertical
    )
  }
}
