//
//  UIImage.swift
//
//  Created by Sereivoan Yong on 11/23/19.
//

#if canImport(UIKit)
import UIKit

@_marker
public protocol UIImageProtocol {

}

extension UIImageProtocol where Self: UIImage {

  public init(size: CGSize, opaque: Bool, scale: CGFloat, actions: (CGContext) -> Void) {
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
    let context = UIGraphicsGetCurrentContext()!
    actions(context)
    // This is the whole purpose of the UIImageInitializable
    self = UIGraphicsGetImageFromCurrentImageContext() as! Self
    UIGraphicsEndImageContext()
  }

  @available(iOS 13.0, *)
  public init(dynamicProvider: (UITraitCollection) -> UIImage) {
    let scaleTraitCollection = UITraitCollection.current

    let lightUnscaledTraitCollection = UITraitCollection(userInterfaceStyle: .light)
    let darkUnscaledTraitCollection = UITraitCollection(userInterfaceStyle: .dark)

    var lightImage = dynamicProvider(lightUnscaledTraitCollection)
    if let configuration = lightImage.configuration {
      lightImage = lightImage.withConfiguration(configuration.withTraitCollection(lightUnscaledTraitCollection))
    }
    var darkImage = dynamicProvider(darkUnscaledTraitCollection)
    if let configuration = darkImage.configuration {
      darkImage = darkImage.withConfiguration(configuration.withTraitCollection(darkUnscaledTraitCollection))
    }
    lightImage.imageAsset!.register(darkImage, with: UITraitCollection(traitsFrom: [scaleTraitCollection, darkUnscaledTraitCollection]))
    self = lightImage as! Self
  }
  
  // https://gist.github.com/timonus/8b4feb47eccb6dde47ca6320d8fc6b11#gistcomment-3176210
  public init(light: @autoclosure () -> Self, dark: @autoclosure () -> Self) {
    if #available(iOS 13.0, *) {
      let scaleTraitCollection = UITraitCollection.current
      
      let lightUnscaledTraitCollection = UITraitCollection(userInterfaceStyle: .light)
      let darkUnscaledTraitCollection = UITraitCollection(userInterfaceStyle: .dark)
      
      let lightScaledTraitCollection = UITraitCollection(traitsFrom: [scaleTraitCollection, lightUnscaledTraitCollection])
      let darkScaledTraitCollection = UITraitCollection(traitsFrom: [scaleTraitCollection, darkUnscaledTraitCollection])
      
      var image: Self!
      lightScaledTraitCollection.performAsCurrent {
        image = light()
        if let configuration = image.configuration {
          image = image.withConfiguration(configuration.withTraitCollection(lightUnscaledTraitCollection)) as? Self
        }
      }
      var darkImage: Self!
      darkScaledTraitCollection.performAsCurrent {
        darkImage = dark()
        if let configuration = darkImage.configuration {
          darkImage = darkImage.withConfiguration(configuration.withTraitCollection(darkUnscaledTraitCollection)) as? Self
        }
      }
      image.imageAsset!.register(darkImage, with: darkScaledTraitCollection)
      self = image
    } else {
      self = light()
    }
  }
}

extension UIImage: UIImageProtocol { }

extension UIImage {
  
  public convenience init?(resourceName: String, extension: String?, in bundle: Bundle = .main) {
    if let path = bundle.path(forResource: resourceName, ofType: `extension`) {
      self.init(contentsOfFile: path)
    } else {
      return nil
    }
  }
  
  public convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1), cornerRadius: CGFloat = 0) {
    self.init(size: size, opaque: false, scale: UIScreen.main.scale) { context in
      context.addPath(CGPath(roundedRect: CGRect(origin: .zero, size: size), cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil))
      context.closePath()
      context.setFillColor(color.cgColor)
      context.fillPath()
    }
  }
  
  final public func resizing(to newSize: CGSize) -> UIImage {
    return UIImage(size: newSize, opaque: false, scale: scale) { _ in
      draw(in: CGRect(origin: .zero, size: newSize))
    }
  }
  
  /// Rotates the image by `angle` radians.
  /// - Parameter angle: The angle, in radians, by which to rotate the image. Positive values rotate counterclockwise and negative values rotate clockwise.
  /// - Returns: The rotated image.
  final public func rotated(by angle: CGFloat) -> UIImage {
    let newSize = CGRect(origin: .zero, size: size).applying(CGAffineTransform(rotationAngle: angle)).size
    return UIImage(size: newSize, opaque: false, scale: scale) { context in
      context.translateBy(x: newSize.width/2, y: newSize.height/2)
      context.rotate(by: angle)
      draw(in: CGRect(x: -size.width/2, y: -size.height/2, width: size.width, height: size.height))
    }
  }
  
  public func trimmingTransparentPixels() -> UIImage {
    let cgImage = self.cgImage!
    let rows = cgImage.height
    let cols = cgImage.width
    let bytesPerRow = cols * MemoryLayout<UInt8>.size
    
    if rows < 2 || cols < 2 {
      return self
    }
    
    // Allocate array to hold alpha channel
    let bitmapData = calloc(rows * cols, MemoryLayout<UInt8>.size).assumingMemoryBound(to: UInt8.self)
    
    // Create alpha-only bitmap context
    let context = CGContext(data: bitmapData, width: cols, height: rows, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.alphaOnly.rawValue)!
    
    // Draw our image on that context
    var rect = CGRect(x: 0, y: 0, width: cols, height: rows)
    context.draw(cgImage, in: rect)
    
    // Summ all non-transparent pixels in every row and every column
    let rowSum = calloc(rows, MemoryLayout<UInt16>.size).assumingMemoryBound(to: UInt16.self)
    let colSum = calloc(cols, MemoryLayout<UInt16>.size).assumingMemoryBound(to: UInt16.self)
    
    // Enumerate through all pixels
    for row in 0..<rows {
      for col in 0..<cols {
        if bitmapData[row * bytesPerRow + col] != 0 { // Found non-transparent pixel
          rowSum[row] += 1
          colSum[col] += 1
        }
      }
    }
    
    // Initialize crop insets and enumerate cols/rows arrays until we find non-empty columns or row
    var crop = UIEdgeInsets.zero
    
    for i in 0..<rows { // Top
      if rowSum[i] > 0 {
        crop.top = CGFloat(i)
        break
      }
    }
    
    for i in (0..<rows).reversed() { // Bottom
      if rowSum[i] > 0 {
        crop.bottom = CGFloat(max(0, rows - i - 1))
        break
      }
    }
    
    for i in 0..<cols { // Left
      if colSum[i] > 0 {
        crop.left = CGFloat(i)
        break
      }
    }
    
    for i in (0..<cols).reversed() { // Right
      if colSum[i] > 0  {
        crop.right = CGFloat(max(0, cols - i - 1))
        break
      }
    }
    
    free(bitmapData)
    free(colSum)
    free(rowSum)
    
    guard crop != .zero else {
      // No cropping needed
      return self
    }
    
    rect.size = rect.size * scale
    
    // Calculate new crop bounds
    rect.x += crop.left
    rect.y += crop.top
    rect.size.width -= crop.left + crop.right
    rect.size.height -= crop.top + crop.bottom
    
    // Crop it
    let newCGImage = cgImage.cropping(to: rect)!
    
    // Convert back to UIImage
    var newImage = UIImage(cgImage: newCGImage, scale: scale, orientation: imageOrientation)
    if capInsets != .zero || resizingMode != .tile {
      newImage = newImage.resizableImage(withCapInsets: capInsets, resizingMode: resizingMode)
    }
    if alignmentRectInsets != .zero {
      newImage = newImage.withAlignmentRectInsets(alignmentRectInsets)
    }
    if renderingMode != .automatic {
      newImage = newImage.withRenderingMode(renderingMode)
    }
    return newImage
  }
}
#endif
