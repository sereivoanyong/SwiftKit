//
//  ViewController.swift
//  ButtonDemo
//
//  Created by Sereivoan Yong on 10/4/23.
//

import UIKitUtilities

class ViewController: UIViewController {

  @IBOutlet weak private var plainButton: Button!
  @IBOutlet weak private var grayButton: Button!
  @IBOutlet weak private var tintedButton: Button!
  @IBOutlet weak private var filledButton: Button!

  @IBOutlet weak private var firstButton: Button!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let button = Button(type: .custom, primaryAction: UIAction(image: UIImage(systemName: "folder")) { _ in

    })
    button.overrideSize = CGSize(40)
    button.configurationStyle = .plain
    button.configurationCornerStyle = .capsule
    button.configurationBaseBackgroundColor = .white
    button.configure()
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)

    firstButton.configurationStyle = .filled
    firstButton.configurationCornerStyle = .capsule

//    plainButton.setTitle("Hello", for: .normal)

    if #available(iOS 15.0, *) {
//      var configuration = plainButton.configuration!
//      configuration.title = "Mango"
//      plainButton.configuration = configuration
//      configuration = UIButton.Configuration.filled()
//      configuration.title = "Mango"
//      plainButton.configuration = configuration
//      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//        self.plainButton.setTitle("LSD", for: .normal)
//      }


      let configurations: [UIButton.Configuration] = [.plain(), .gray(), .tinted(), .filled()]
      let bcConfigurations: [Button.BCConfiguration] = [.init(style: .plain), .init(style: .gray), .init(style: .tinted), .init(style: .filled)]
      for (configuration, bcConfiguration) in zip(configurations, bcConfigurations) {
        
        var configuration = configuration
        var bcConfiguration = bcConfiguration

        for (size, bcSize) in zip(UIButton.Configuration.Size.allCases, Button.BCConfiguration.Size.allCases) {
          configuration.buttonSize = size
          bcConfiguration.size = bcSize

          for (cornerStyle, bcCornerStyle) in zip(UIButton.Configuration.CornerStyle.allCases, Button.BCConfiguration.CornerStyle.allCases) {
            configuration.cornerStyle = cornerStyle
            bcConfiguration.cornerStyle = bcCornerStyle

            //          mini dynamic 14.0
            //          small dynamic 14.0
            //          medium dynamic 5.949999999999999
            //          large dynamic 8.75
//            print(configuration.cornerStyle, configuration.background.cornerRadius)
            //          assert(configuration.background.cornerRadius == bcConfiguration.background.cornerRadius)

            print("Size: \(configuration.buttonSize) | Corner Style: \(configuration.cornerStyle) | Corner Radius: \(configuration.background.cornerRadius)")
          }
          print("---")

//          mini dynamic 14.0
//          small dynamic 14.0
//          medium dynamic 5.949999999999999
//          large dynamic 8.75

          assert(configuration.contentInsets == bcConfiguration.contentInsets)
          assert(configuration.imagePadding == bcConfiguration.imagePadding)
        }

      }
    }
  }
}

extension UIButton.Configuration.Size: CaseIterable {

  public static var allCases: [Self] {
    return [.mini, .small, .medium, .large]
  }
}

extension UIButton.Configuration.CornerStyle: CaseIterable {

  public static var allCases: [Self] {
    return [.fixed, .dynamic, .small, .medium, .large]
  }
}
