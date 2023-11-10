//
//  EmptyView.swift
//
//  Created by Sereivoan Yong on 4/30/21.
//

#if os(iOS)

import UIKit

public protocol EmptyViewDataSource: AnyObject {

  func emptyView(_ emptyView: EmptyView, configureContentFor state: EmptyView.State)
  func emptyViewPrepareForReuse(_ emptyView: EmptyView)
}

extension EmptyViewDataSource {

  public func emptyViewPrepareForReuse(_ emptyView: EmptyView) {
    emptyView.reset()
  }
}

extension EmptyView {

  public enum State: Equatable {

    case empty
    case error(Error)

    public static func == (lhs: Self, rhs: Self) -> Bool {
      switch (lhs, rhs) {
      case (.empty, .empty):
        return true
      case (.empty, .error), (.error, .empty):
        return false
      case (.error(let lhs), .error(let rhs)):
        return AnyEquatableError(error: lhs) == AnyEquatableError(error: rhs)
      }
    }
  }
}

open class EmptyView: UIView {

  // This is not needed if the empty view is attached to either `UICollectionView` or `UITableView`,
  // and the provided state is never `.error`
  weak open var stateProvider: EmptyViewStateProviding?

  weak open var dataSource: EmptyViewDataSource?

  open private(set) var state: State? {
    didSet {
      prepareForReuse()
      if let state = state {
        dataSource?.emptyView(self, configureContentFor: state)
        reloadHiddenStates()
        isHidden = false
      } else {
        isHidden = true
      }
    }
  }

  // MARK: Public Properties

  public let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .center
    stackView.spacing = 8
    return stackView
  }()

  private var _imageView: UIImageView?
  lazy open private(set) var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    stackView.insertArrangedSubview(imageView, at: 0)
    _imageView = imageView
    return imageView
  }()

  private var _titleLabel: UILabel?
  lazy open private(set) var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 27)
    label.textAlignment = .center
    label.textColor = UIColor(white: 0.6, alpha: 1)
    label.numberOfLines = 0
    if let _imageView = _imageView, let index = stackView.arrangedSubviews.firstIndex(of: _imageView) {
      stackView.insertArrangedSubview(label, at: index + 1)
    } else {
      stackView.insertArrangedSubview(label, at: 0)
    }
    _titleLabel = label
    return label
  }()

  private var _messageLabel: UILabel?
  lazy open private(set) var messageLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 17)
    label.textAlignment = .center
    label.textColor = UIColor(white: 0.6, alpha: 1)
    label.numberOfLines = 0
    if let _titleLabel = _titleLabel, let index = stackView.arrangedSubviews.firstIndex(of: _titleLabel) {
      stackView.insertArrangedSubview(label, at: index + 1)
    } else if let _imageView = _imageView, let index = stackView.arrangedSubviews.firstIndex(of: _imageView) {
      stackView.insertArrangedSubview(label, at: index + 1)
    } else {
      stackView.insertArrangedSubview(label, at: 0)
    }
    _messageLabel = label
    return label
  }()

  private var _button: UIButton?
  lazy open private(set) var button: UIButton = {
    let button = UIButton(type: .system)
    stackView.addArrangedSubview(button)
    _button = button
    return button
  }()

  open var image: UIImage? {
    get { return _imageView?.image }
    set {
      if let _imageView = _imageView {
        _imageView.image = newValue
      } else if let newValue = newValue {
        imageView.image = newValue
      }
    }
  }

  open var title: String? {
    get { return _titleLabel?.text }
    set {
      if let _titleLabel = _titleLabel {
        _titleLabel.text = newValue
      } else if let newValue = newValue, !newValue.isEmpty {
        titleLabel.text = newValue
      }
    }
  }

  open var attributedTitle: NSAttributedString? {
    get { return _titleLabel?.attributedText }
    set {
      if let _titleLabel = _titleLabel {
        _titleLabel.attributedText = newValue
      } else if let newValue = newValue {
        titleLabel.attributedText = newValue
      }
    }
  }

  open var message: String? {
    get { return _messageLabel?.text }
    set {
      if let _messageLabel = _messageLabel {
        _messageLabel.text = newValue
      } else if let newValue = newValue, !newValue.isEmpty {
        messageLabel.text = newValue
      }
    }
  }

  open var attributedMessage: NSAttributedString? {
    get { return _messageLabel?.attributedText }
    set {
      if let _messageLabel = _messageLabel {
        _messageLabel.attributedText = newValue
      } else if let newValue = newValue {
        messageLabel.attributedText = newValue
      }
    }
  }

  // MARK: Initializers

  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    commonInit()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    isHidden = true

    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leftAnchor.constraint(equalTo: leftAnchor),
      bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
      rightAnchor.constraint(equalTo: stackView.rightAnchor)
    ])
  }

  // MARK: Public

  // This is called automatically if the empty view is either `UICollectionView` or `UITableView`
  open func reload() {
    if let stateProvider = stateProvider ?? superview as? EmptyViewStateProviding {
      state = stateProvider.state(for: self)
    } else {
      state = nil
    }
  }

  open func prepareForReuse() {
    if let dataSource = dataSource {
      dataSource.emptyViewPrepareForReuse(self)
    } else {
      reset()
    }
  }

  // MARK: Internal

  @usableFromInline
  func reset() {
    if let _imageView = _imageView {
      _imageView.image = nil
    }
    if let _titleLabel = _titleLabel {
      _titleLabel.text = nil
      _titleLabel.attributedText = nil
    }
    if let _messageLabel = _messageLabel {
      _messageLabel.text = nil
      _messageLabel.attributedText = nil
    }
    if let _button = _button {
      _button.setTitle(nil, for: .normal)
      _button.setAttributedTitle(nil, for: .normal)
      _button.setImage(nil, for: .normal)
      _button.setBackgroundImage(nil, for: .normal)
      if #available(iOS 13.0, *) {
        _button.setPreferredSymbolConfiguration(nil, forImageIn: .normal)
      }
    }
    reloadHiddenStates()
  }

  // MARK: Private

  private func reloadHiddenStates() {
    if let _imageView = _imageView {
      _imageView.isHidden = _imageView.image == nil
    }
    if let _titleLabel = _titleLabel {
      _titleLabel.isHidden = _titleLabel.text == nil && _titleLabel.attributedText == nil
    }
    if let _messageLabel = _messageLabel {
      _messageLabel.isHidden = _messageLabel.text == nil && _messageLabel.attributedText == nil
    }
    if let _button = _button {
      _button.isHidden = !_button.hasContent
    }
  }
}

extension UIButton {

  fileprivate var hasContent: Bool {
    if currentTitle != nil {
      return true
    }
    if currentAttributedTitle != nil {
      return true
    }
    if currentImage != nil {
      return true
    }
    if currentBackgroundImage != nil {
      return true
    }
    if #available(iOS 13.0, *), currentPreferredSymbolConfiguration != nil {
      return true
    }
    return false
  }
}

#endif
