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
    let item = _configuration.item
    var newButtonConfiguration = buttonConfiguration
    newButtonConfiguration.attributedTitle = AttributedString(item.currentTitle, attributes: .init()
      .font(Self.nameFont)
    )
    switch item.valueSelection {
    case .toggleSelection:
      button.showsMenuAsPrimaryAction = false
      button.menu = nil
      button.addAction(UIAction(title: item.currentTitle, identifier: UIAction.Identifier("toggle")) { [unowned self] _ in
        let item = _configuration.item as! any ToggleFilterItem
        item.isSelected.toggle()
        button.isSelected = item.isSelected
        collectionView?.collectionViewLayout.invalidateLayout()
      }, for: .primaryActionTriggered)

    case .selection(let valuesProvider, let actionConfigurationProvider, let isCollection, let isEqual):
      button.showsMenuAsPrimaryAction = true
      button.menu = UIMenu(children: [UIDeferredMenuElement.uncached { [unowned self] actionsProvider in
        valuesProvider({ [unowned self] values in
          let isSelected: (Any) -> Bool
          if isCollection {
            let item = _configuration.item as! any ValuesFilterItem
            let selectedValues = item.anySelectedValues
            isSelected = { value in
              for selectedValue in selectedValues {
                if isEqual(value, selectedValue) {
                  return true
                }
              }
              return false
            }
          } else {
            let item = _configuration.item as! any ValueFilterItem
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
              if isCollection {
                let item = _configuration.item as! any ValuesFilterItem
                var indexToRemove: Int?
                for (index, selectedValue) in item.anySelectedValues.enumerated() {
                  if isEqual(value, selectedValue) {
                    indexToRemove = index
                    break
                  }
                }
                if let indexToRemove {
                  item.anySelectedValues.remove(at: indexToRemove)
                } else {
                  item.anySelectedValues.append(value)
                }
              } else {
                let item = _configuration.item as! any ValueFilterItem
                if let anySelectedValue = item.anySelectedValue, isEqual(anySelectedValue, value) {
                  item.anySelectedValue = nil
                } else {
                  item.anySelectedValue = value
                }
              }
              buttonConfiguration.attributedTitle = AttributedString(item.currentTitle, attributes: .init()
                .font(Self.nameFont)
              )
              button.isSelected = item.isSelected
              collectionView?.collectionViewLayout.invalidateLayout()
            }
          })
        })
      }])
      button.isSelected = item.isSelected
    }
    switch item.valueSelection {
    case .toggleSelection:
      newButtonConfiguration.image = nil
    case .selection:
      newButtonConfiguration.image = Self.chevronDownImage
    }
    buttonConfiguration = newButtonConfiguration
  }

  static func size(for item: any FilterItemInternal, traitCollection: UITraitCollection) -> CGSize {
    let displayScale = traitCollection.nonZeroDisplayScale
    let titleSize = (item.currentTitle as NSString).size(withAttributes: [.font: nameFont])
    var width = titleSize.width.ceiledToPixel(scale: displayScale)
    switch item.valueSelection {
    case .toggleSelection:
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
