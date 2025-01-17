//
//  VariableBlurEffectView.swift
//
//  Created by Sereivoan Yong on 1/17/25.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

@available(iOS 13.0, *)
extension VariableBlurEffectView {

  /// The possible directions that the gradient of this blur view may flow in.
  public enum Direction {

    case down   // Downwards. Useful for the iOS status bar
    case up     // Upwards. Useful for view controller toolbars
    case left   // Left. Useful for iPadOS sidebar
    case right  // Right. iPadOS sidebar in right-to-left locales
  }

  /// An absolute or relative amount of sizing used to customize the appearence of the blur and gradient views.
  public enum GradientSizing {

    // The amount of on-screen UI points starting from the origin, as a static value.
    case absolute(position: CGFloat)
    // A value between 0.0 and 1.0 relative to the size of the view. A value of 0.5 would be half the size of this view.
    case relative(fraction: CGFloat)
  }

  /// The amount of alpha applied to the colored gradient view over the blur view to add more contrast
  public enum DimmingAlpha {

    // A constant value shared between any interface styles.
    case constant(CGFloat)
    // Different values between any and dark interface styles.
    case interfaceStyle(any: CGFloat, dark: CGFloat)
  }
}

/// A variant of UIVisualEffectView that provides a blur overlay view
/// that gradually 'ramps' up in blur intensity from one edge to the other.
/// This is great for separating separate layers of content (such as the iOS status bar)
/// without any hard border lines.
@available(iOS 13.0, *)
open class VariableBlurEffectView: UIVisualEffectView {

  /// The current direction of the gradient for this blur view
  public var direction: Direction = .down {
    didSet { reset() }
  }

  /// The maximum blur radius of the blur view when its gradient is at full opacity
  public var maximumBlurRadius: Double = 3.5 {
    didSet { updateBlurFilter() }
  }

  /// An optional amount of insetting from the opaque side where the blur reaches 100%.
  public var blurStartingInset: GradientSizing? {
    didSet { resetBlurMask() }
  }

  /// An optional colored gradient to dim the underlying content for better contrast.
  public var dimmingTintColor: UIColor? = .systemBackground {
    didSet {
      makeDimmingViewIfNeeded()
      dimmingView?.tintColor = dimmingTintColor
    }
  }

  /// The alpha value of the colored gradient
  public var dimmingAlpha: DimmingAlpha? = .interfaceStyle(any: 0.65, dark: 0.25) {
    didSet { setNeedsLayout() }
  }

  /// An optional overshoot value to allow the colored gradient to extend outside the blur view's bounds
  public var dimmingOvershoot: GradientSizing? = .relative(fraction: 0.25) {
    didSet { resetDimmingImage() }
  }

  /// An optional inset position where the colored gradient hits 100% of its transition.
  public var dimmingStartingInset: GradientSizing? {
    didSet { resetDimmingImage() }
  }

  /// Performs an update when the frame changes
  public override var frame: CGRect {
    didSet { resetForBoundsChange(oldValue: oldValue) }
  }

  /// The variable blur view filter
  private let variableBlurFilter = BlurFilterProvider.blurFilter(named: "variableBlur")

  /// The current image being used as the gradient mask
  private var gradientMaskImage: CGImage?

  /// Track when the images need to be regenerated
  private var needsUpdate: Bool = false

  /// An optional dimming gradient shown along with the blur view
  private var dimmingView: UIImageView?

  // MARK: - Initialization

  public init() {
    super.init(effect: UIBlurEffect(style: .regular))
    commonInit()
  }

  public init(frame: CGRect) {
    super.init(effect: UIBlurEffect(style: .regular))
    commonInit()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    effect = UIBlurEffect(style: .regular)
    commonInit()
  }

  private func commonInit() {
    // Disable interaction so touches will pass through it
    isUserInteractionEnabled = false
  }

  // MARK: - View Lifecycle

  public override func didMoveToSuperview() {
    super.didMoveToSuperview()
    configureView()
    updateBlurFilter()
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    updateBlurFilter()

    dimmingView?.frame = dimmingViewFrame()
    updateDimmingViewAlpha()

    guard needsUpdate else { return }
    generateImagesAsNeeded()
    needsUpdate = false
  }

  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    configureView()
    updateBlurFilter()
    updateDimmingViewAlpha()
  }

  // MARK: - Private

  // One-time setup logic to configure the blur view with our filters
  private func configureView() {
    guard superview != nil, let variableBlurFilter else { return }

    // Find the overlay view (The one that lightens or darkens these blur views) and hide it.
    BlurFilterProvider.findSubview(in: self, containing: "subview")?.isHidden = true

    // Find the backdrop view (The one that repeats the content drawn behind it) and apply the blur filter.
    if let backdropView = BlurFilterProvider.findSubview(in: self, containing: "backdrop") {
      backdropView.layer.filters = [variableBlurFilter]
      backdropView.layer.setValue(0.75, forKey: "scale")
    }
  }

  // Sets up (or tears down) an image view to display the dimming gradient as needed
  private func makeDimmingViewIfNeeded() {
    guard let dimmingTintColor else {
      dimmingView?.removeFromSuperview()
      dimmingView = nil
      return
    }

    guard dimmingView == nil else {
      return
    }

    let imageView = UIImageView()
    imageView.tintColor = dimmingTintColor
    contentView.addSubview(imageView)

    dimmingView = imageView
    setNeedsUpdate()
  }

  // Update the parameters of the blur filter when the state in this view changes
  private func updateBlurFilter() {
    variableBlurFilter?.setValue(gradientMaskImage, forKey: "inputMaskImage")
    variableBlurFilter?.setValue(maximumBlurRadius, forKey: "inputRadius")
    variableBlurFilter?.setValue(true, forKey: "inputNormalizeEdges")
  }

  // Update the alpha value of the colored gradient as needed
  private func updateDimmingViewAlpha() {
    guard let dimmingAlpha else {
      dimmingView?.alpha = 0.0
      return
    }

    switch dimmingAlpha {
    case .constant(let alpha):
      dimmingView?.alpha = alpha
    case .interfaceStyle(let alphaForAny, let alphaForDark):
      let isDark = traitCollection.userInterfaceStyle == .dark
      dimmingView?.alpha = isDark ? alphaForDark : alphaForAny
    }
  }

  // Layout the dimming view, taking direction and overshoot into account
  private func dimmingViewFrame() -> CGRect {
    var frame = bounds
    switch direction {
    case .down, .up:
      let adjustedHeight = applyOvershoot(to: frame.height, overshoot: dimmingOvershoot)
      frame.size.height = adjustedHeight
      frame.origin.y = direction == .up ? -(adjustedHeight - bounds.height) : 0.0
    case .left, .right:
      let adjustedWidth = applyOvershoot(to: frame.width, overshoot: dimmingOvershoot)
      frame.size.width = adjustedWidth
      frame.origin.x = direction == .left ? -(adjustedWidth - bounds.width) : 0.0
    }
    return frame
  }
}

// MARK: Image Reset

@available(iOS 13.0, *)
extension VariableBlurEffectView {

  // Reset if a bounds change means we have to regenerate the images
  private func resetForBoundsChange(oldValue: CGRect) {
    let needsReset: Bool
    switch direction {
    case .down, .up:
      needsReset = frame.height != oldValue.height
    case .left, .right:
      needsReset = frame.width != oldValue.width
    }
    guard needsReset else { return }
    reset()
  }

  // Reset both the blur mask, and the dimming gradient
  private func reset() {
    resetBlurMask()
    resetDimmingImage()
  }

  // Some state changed to the point where we need to regenerate the blur mask image
  private func resetBlurMask() {
    gradientMaskImage = nil
    setNeedsUpdate()
  }

  // Some state changed to the point where we need to regenerate the dimming mask image
  private func resetDimmingImage() {
    dimmingView?.image = nil
    setNeedsUpdate()
  }

  // Sets that the blur view needs to be updated in the next layout pass
  // This allows a variety of settings to be set in one run loop, with them all being applied next loop
  private func setNeedsUpdate() {
    needsUpdate = true
    setNeedsLayout()
  }
}

// MARK: Image Generation
@available(iOS 13.0, *)
extension VariableBlurEffectView {

  private func generateImagesAsNeeded() {
    // Update the blur view's gradient mask
    if gradientMaskImage == nil {
      gradientMaskImage = fetchGradientImage(startingInset: blurStartingInset)
      updateBlurFilter()
    }

    // Update the dimming view image
    if dimmingView?.image == nil {
      makeDimmingViewIfNeeded()
      if let dimmingImage = fetchGradientImage(startingInset: dimmingStartingInset, smooth: true, overshoot: dimmingOvershoot) {
        dimmingView?.image = UIImage(cgImage: dimmingImage).withRenderingMode(.alwaysTemplate)
      }
    }
  }

  // Generates a gradient bitmap to be used with the blur filter
  private func fetchGradientImage(startingInset: GradientSizing?, smooth: Bool = false, overshoot: GradientSizing? = nil) -> CGImage? {
    // Skip if we're not sized yet.
    guard frame.size.width != 0.0 && frame.size.height != 0.0 else { return nil }

    // Generate the size, based on the current direction
    let size: CGSize
    switch direction {
    case .up, .down:
      size = CGSize(width: 1.0, height: applyOvershoot(to: bounds.height, overshoot: overshoot))
    case .left, .right:
      size = CGSize(width: applyOvershoot(to: bounds.width, overshoot: overshoot), height: 1.0)
    }

    // Determine the start location if a setting was provided
    let startLocation: CGFloat
    if let startingInset {
      switch startingInset {
      case .absolute(let position):
        startLocation = position / (size.width < size.height ? size.height : size.width)
      case .relative(let fraction):
        startLocation = fraction
      }
    } else {
      startLocation = 0
    }

    // Determine which direction the gradient flows in
    // (Core Image has its origin at the bottom of the bounds)
    let gradientPosition: (start: CGPoint, end: CGPoint)
    switch direction {
    case .down:
      gradientPosition = (start: CGPoint(x: 0.5, y: bounds.height - (bounds.height * startLocation)), end: CGPoint(x: 0.5, y: 0.0))
    case .up:
      gradientPosition = (start: CGPoint(x: 0.5, y: 0.0 + (bounds.height * startLocation)), end: CGPoint(x: 0.5, y: bounds.height))
    case .left:
      gradientPosition = (start: CGPoint(x: bounds.width - (bounds.width * startLocation), y: 0.5), end: CGPoint(x: 0.0, y: 0.5))
    case .right:
      gradientPosition = (start: CGPoint(x: 0.0 + (bounds.width * startLocation), y: 0.5), end: CGPoint(x: bounds.width, y: 0.5))
    }

    // Configure one color to be opaque and one to be clear
    let startColor = CIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let endColor = CIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)

    // Create a Core Image smooth linear gradient, since the classic Core Graphics gradient seems
    // to have a much harsher starting line at the edge of the gradient
    let gradientImage: CIImage?
    if smooth {
      let gradientFilter = CIFilter.smoothLinearGradient()
      gradientFilter.setDefaults()
      gradientFilter.point0 = gradientPosition.start
      gradientFilter.point1 = gradientPosition.end
      gradientFilter.color0 = startColor
      gradientFilter.color1 = endColor
      gradientImage = gradientFilter.outputImage
    } else {
      let gradientFilter = CIFilter.linearGradient()
      gradientFilter.setDefaults()
      gradientFilter.point0 = gradientPosition.start
      gradientFilter.point1 = gradientPosition.end
      gradientFilter.color0 = startColor
      gradientFilter.color1 = endColor
      gradientImage = gradientFilter.outputImage
    }

    // Render the image out as a CGImage
    guard let gradientImage else { return nil }
    return CIContext(options: [.useSoftwareRenderer: true])
      .createCGImage(gradientImage, from: CGRect(origin: .zero, size: size))
  }

  // Apply an optional overshoot value to this image
  private func applyOvershoot(to value: CGFloat, overshoot: GradientSizing?) -> CGFloat {
    guard let overshoot else { return value }
    switch overshoot {
    case .absolute(let position):
      return value + position
    case .relative(let fraction):
      return value + (value * fraction)
    }
  }
}

// An internal class that creates, manages and vends the blur filters
// used by the public classes of this framework.
@MainActor final private class BlurFilterProvider {

  // A shared blur visual effect view that is used to hook and extract a reference to the CAFilter class
  static let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

  /// Vends a newly instantiated CAFilter instance with the provided filter name
  /// - Parameter name: The name of the filter that this filter should be instantiated with
  /// - Returns: The new CAFilter object, or nil if the filter if it couldn't be created.
  static func blurFilter(named name: String) -> NSObject? {
    // The only private method we need to call is '+[CAFilter filterWithType:]'
    var selectorComponents: [String] = ["Type:", "With", "filter"]
    selectorComponents.reverse()
    let selector = NSSelectorFromString(selectorComponents.joined())

    // Fetch a known CAFilter-backed subview from out of the shared blur view so we can access that class.
    guard let backdropView = findSubview(in: blurView, containing: "backdrop"),
          let filter = backdropView.layer.filters?.first as? NSObject else {
      return nil
    }

    // Confirm the class that was extracted implements the method name we need.
    // This ensures that even if Apple changes it, we can fail gracefully.
    let type = type(of: filter)
    guard type.responds(to: selector) else { return nil }
    return type.perform(selector, with: name)?.takeUnretainedValue() as? NSObject
  }

  /// Loop through a view's subviews and find the one with its class name containing the provided string
  /// - Parameter view: The view whose subviews will be searched.
  /// - Parameter name: The portion of the name of the subiew to find.
  /// - Returns: The subview if it is found, or nil otherwise.
  static func findSubview(in view: UIView, containing name: String) -> UIView? {
    let name = name.lowercased()
    return view.subviews.first { "\(type(of: $0))".lowercased().contains(name) }
  }
}
