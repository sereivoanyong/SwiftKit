//
//  WKWebViewController.swift
//
//  Created by Sereivoan Yong on 10/5/23.
//

import UIKit
import SwiftKit
import WebKit

open class WKWebViewController: UIViewController {

  private var webViewTitleObservation: NSKeyValueObservation?

  private var _webView: WKWebView!

  open weak var webView: WKWebView! {
    get {
      if _webView == nil {
        loadWebView()
        webViewDidLoad()
      }
      return _webView
    }
    set {
      precondition(_webView == nil, "Collection view can only be set before it is loaded.")
      _webView = newValue
      webViewDidLoad()
    }
  }

  private var _webViewConfiguration: WKWebViewConfiguration!
  open var webViewConfiguration: WKWebViewConfiguration {
    if _webViewConfiguration == nil {
      _webViewConfiguration = makeWebViewConfiguration()
    }
    return _webViewConfiguration
  }

  lazy private var activityIndicatorView: UIActivityIndicatorView = {
    var activityIndicator = UIActivityIndicatorView(style: .grayOrMedium)
    activityIndicator.sizeToFit()
    return activityIndicator
  }()

  open var usesWebViewTitleAsNavigationTitle: Bool = false {
    didSet {
      guard usesWebViewTitleAsNavigationTitle != oldValue else { return }
      if usesWebViewTitleAsNavigationTitle {
        if isViewLoaded {
          webViewTitleObservation = webView.observe(\.title, options: [.initial, .new]) { [unowned self] webView, _ in
            navigationItem.title = webView.title
          }
        }
      } else {
        webViewTitleObservation = nil
      }
    }
  }

  open var request: WKWebView.Request? {
    willSet {
      webView.stopLoading()
    }
    didSet {
      if let request, isViewLoaded {
        webView.load(request)
      }
    }
  }

  // MARK: Init / Deinit

  public convenience init(request: WKWebView.Request?) {
    self.init(nibName: nil, bundle: nil)
    self.request = request
  }

  // MARK: Web View Lifecycle

  open func makeWebViewConfiguration() -> WKWebViewConfiguration {
    let configuration = WKWebViewConfiguration()
    configuration.userContentController = WKUserContentController()
    configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
    return configuration
  }

  open func loadWebView() {
    let webView = WKWebView(frame: UIScreen.main.bounds, configuration: webViewConfiguration)
    webView.navigationDelegate = self
    self.webView = webView
  }

  open var webViewIfLoaded: WKWebView? {
    return _webView
  }

  open func webViewDidLoad() {
  }

  open var isWebViewLoaded: Bool {
    return _webView != nil
  }

  // MARK: View Lifecycle

  open override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground()

    webView.frame = view.bounds
    webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(webView)

    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(activityIndicatorView)

    NSLayoutConstraint.activate([
      activityIndicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      activityIndicatorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
    ])

    if usesWebViewTitleAsNavigationTitle {
      webViewTitleObservation = webView.observe(\.title, options: [.initial, .new]) { [unowned self] webView, _ in
        navigationItem.title = webView.title
      }
    }

    if let request {
      webView.load(request)
    }
  }

  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // See: https://developer.apple.com/forums/thread/114740
    if let request, request.isFile {
      webView.load(request)
    }
  }
}

extension WKWebViewController: WKNavigationDelegate {

  open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    activityIndicatorView.startAnimating()
  }

  open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    activityIndicatorView.stopAnimating()
  }
}
