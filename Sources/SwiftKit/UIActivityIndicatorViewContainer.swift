//
//  UIActivityIndicatorViewContainer.swift
//
//  Created by Sereivoan Yong on 11/28/19.
//

import UIKit

public protocol UIActivityIndicatorViewContainer: AnyObject {
  
  var activityIndicatorView: UIActivityIndicatorView { get }
  func startAnimatingActivityIndicatorView()
  func stopAnimatingActivityIndicatorView()
}

extension UIActivityIndicatorViewContainer {
  
  public func startAnimatingActivityIndicatorView() {
    activityIndicatorView.startAnimating()
  }
  
  public func stopAnimatingActivityIndicatorView() {
    activityIndicatorView.stopAnimating()
  }
}

private var kLoadingIndicatorViewKey: Void?

extension UIActivityIndicatorViewContainer where Self: UIView {
  
  public var activityIndicatorView: UIActivityIndicatorView {
    if let loadingIndicatorView = objc_getAssociatedObject(self, &kLoadingIndicatorViewKey) as? UIActivityIndicatorView {
      return loadingIndicatorView
    }
    let loadingIndicatorView: UIActivityIndicatorView
    if #available(iOS 13.0, *) {
      loadingIndicatorView = UIActivityIndicatorView(style: .medium)
    } else {
      loadingIndicatorView = UIActivityIndicatorView(style: .gray)
    }
    loadingIndicatorView.hidesWhenStopped = true
    loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(loadingIndicatorView)
    
    NSLayoutConstraint.activate([
      loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
      loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
    objc_setAssociatedObject(self, &kLoadingIndicatorViewKey, loadingIndicatorView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    return loadingIndicatorView
  }
  
  public func startAnimatingActivityIndicatorView() {
    activityIndicatorView.startAnimating()
    isUserInteractionEnabled = false
  }
  
  public func stopAnimatingActivityIndicatorView() {
    activityIndicatorView.stopAnimating()
    isUserInteractionEnabled = true
  }
}

extension UIActivityIndicatorViewContainer where Self: UIViewController {
  
  public var activityIndicatorView: UIActivityIndicatorView {
    if let loadingIndicatorView = objc_getAssociatedObject(self, &kLoadingIndicatorViewKey) as? UIActivityIndicatorView {
      return loadingIndicatorView
    }
    let loadingIndicatorView: UIActivityIndicatorView
    if #available(iOS 13.0, *) {
      loadingIndicatorView = UIActivityIndicatorView(style: .medium)
    } else {
      loadingIndicatorView = UIActivityIndicatorView(style: .gray)
    }
    loadingIndicatorView.hidesWhenStopped = true
    loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(loadingIndicatorView)
    
    NSLayoutConstraint.activate([
      loadingIndicatorView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
      loadingIndicatorView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
    ])
    objc_setAssociatedObject(self, &kLoadingIndicatorViewKey, loadingIndicatorView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    return loadingIndicatorView
  }
}
