//
//  NavigationController.CrossDissolveAnimator.swift
//
//  Created by Sereivoan Yong on 11/1/23.
//

import UIKit

extension NavigationController {

  open class CrossDissolveAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    public let operation: Operation
    public let animationDuration: TimeInterval = 0.25

    public init(operation: UINavigationController.Operation) {
      self.operation = operation
    }

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return animationDuration
    }

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      switch operation {
      case .push:
        let fromVC = transitionContext.viewController(forKey: .from)!
        transitionContext.containerView.addSubview(fromVC.view)

        let toVC = transitionContext.viewController(forKey: .to)!
        toVC.view.alpha = 0
        transitionContext.containerView.addSubview(toVC.view)

        UIView.animate(
          withDuration: animationDuration,
          animations: {
            toVC.view.alpha = 1
          },
          completion: { _ in
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
          }
        )

      case .pop:
        let toVC = transitionContext.viewController(forKey: .to)!
        transitionContext.containerView.addSubview(toVC.view)

        let fromVC = transitionContext.viewController(forKey: .from)!
        transitionContext.containerView.addSubview(fromVC.view)

        UIView.animate(
          withDuration: animationDuration,
          animations: {
            fromVC.view.alpha = 0
          },
          completion: { _ in
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
          }
        )

      default:
        break
      }
    }
  }
}
