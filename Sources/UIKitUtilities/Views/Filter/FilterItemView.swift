//
//  FilterItemView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 4/15/25.
//

import UIKit
import SwiftKit

@available(iOS 15.0, *)
final class FilterItemView: UIView, UIContentView {

  private static var chevronDownImage: UIImage? {
    return UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(textStyle: .emphasizedBody, scale: .small))
  }

  static let baseButtonConfiguration: UIButton.Configuration = {
    var configuration: UIButton.Configuration
    if #available(iOS 26.0, *) {
      configuration = .glass()
      configuration.cornerStyle = .capsule
    } else {
      configuration = .tinted()
      configuration.imageColorTransformer = .init { _ in .tertiaryLabel }
      configuration.baseForegroundColor = .label
      configuration.baseBackgroundColor = .clear
      configuration.background.visualEffect = UIBlurEffect(style: .systemMaterial)
      configuration.cornerStyle = .fixed
      configuration.background.cornerRadius = 10
    }
    configuration.buttonSize = .mini
    configuration.imagePadding = 4
    configuration.imagePlacement = .trailing
    return configuration
  }()

  static var nameFont: UIFont {
    return .systemFont(ofSize: 12, weight: .medium)
  }

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

  fileprivate var collectionView: UICollectionView? {
    var superview = superview
    while let targetSuperview = superview {
      if let collectionView = targetSuperview as? UICollectionView {
        return collectionView
      }
      superview = targetSuperview.superview
    }
    return nil
  }

  init(configuration: FilterItemContentConfiguration) {
    buttonConfiguration = Self.baseButtonConfiguration
    button = UIButton(configuration: buttonConfiguration)
    button.configurationUpdateHandler = { button in
      var configuration = button.configuration!
      if button.isSelected {
        // Style for filled
        configuration.imageColorTransformer = .init { _ in .tertiaryLabel.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark)) }
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = nil
      } else {
        configuration.imageColorTransformer = .init { _ in .tertiaryLabel }
        configuration.baseForegroundColor = .label
        configuration.baseBackgroundColor = .clear
      }
      button.configuration = configuration
    }
    _configuration = configuration
    super.init(frame: .zero)

    reloadData()
    addSubview(button)

    button.translatesAutoresizingMaskIntoConstraints = false
    button.directionalAnchors.constraints(equalTo: directionalAnchors).activate()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func reloadData() {
    let toggleActionIdentifier = UIAction.Identifier("ToggleAction")
    let item = _configuration.item
    switch item.configuration {
    case .toggle:
      button.showsMenuAsPrimaryAction = false
      button.menu = nil
      button.addAction(UIAction(title: item.currentTitle, identifier: toggleActionIdentifier) { [unowned self] _ in
        let item = _configuration.item as! any ToggleFilterItemProtocol
        item.isSelected.toggle()
        button.isSelected = item.isSelected
        collectionView?.collectionViewLayout.invalidateLayout()
      }, for: .primaryActionTriggered)

    case .selection(let valuesProvider, let actionConfigurationProvider, let isEqual):
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
                collectionView?.collectionViewLayout.invalidateLayout()
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
      newButtonConfiguration.image = Self.chevronDownImage
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
