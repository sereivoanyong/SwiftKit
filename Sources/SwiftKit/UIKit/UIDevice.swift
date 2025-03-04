//
//  UIDevice.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

import UIKit

// MacBookPro18,1 on iOS simulator & Mac Catalyst
public func sysctlModel() -> String {
  var size: size_t = 0
  sysctlbyname("hw.model", nil, &size, nil, 0) // Get size of the buffer
  var model = [CChar](repeating: 0, count: size)
  sysctlbyname("hw.model", &model, &size, nil, 0) // Get model name
  return String(cString: model)
}

// arm64 on iOS simulator & Mac Catalyst
public func sysctlMachine() -> String {
  var size: size_t = 0
  sysctlbyname("hw.machine", nil, &size, nil, 0)
  var machine = [CChar](repeating: 0, count: size)
  sysctlbyname("hw.machine", &machine, &size, nil, 0)
  return String(cString: machine)
}

extension UIDevice {
  
  /* Source: https://stackoverflow.com/a/24205085/11235826
   ActiveWirelessTechnology
   AirplaneMode
   assistant
   BasebandCertId
   BasebandChipId
   BasebandPostponementStatus
   BasebandStatus
   BatteryCurrentCapacity
   BatteryIsCharging
   BluetoothAddress
   BoardId
   BootNonce
   BuildVersion
   CertificateProductionStatus
   CertificateSecurityMode
   ChipID
   CompassCalibrationDictionary
   CPUArchitecture
   DeviceClass
   DeviceColor
   DeviceEnclosureColor
   DeviceEnclosureRGBColor
   DeviceName
   DeviceRGBColor
   DeviceSupportsFaceTime
   DeviceVariant
   DeviceVariantGuess
   DiagData
   dictation
   DiskUsage
   EffectiveProductionStatus
   EffectiveProductionStatusAp
   EffectiveProductionStatusSEP
   EffectiveSecurityMode
   EffectiveSecurityModeAp
   EffectiveSecurityModeSEP
   FirmwarePreflightInfo
   FirmwareVersion
   FrontFacingCameraHFRCapability
   HardwarePlatform
   HasSEP
   HWModelStr
   Image4Supported
   InternalBuild
   InverseDeviceID
   ipad
   MixAndMatchPrevention
   MLBSerialNumber
   MobileSubscriberCountryCode
   MobileSubscriberNetworkCode
   ModelNumber
   PartitionType
   PasswordProtected
   ProductName
   ProductType
   ProductVersion
   ProximitySensorCalibrationDictionary
   RearFacingCameraHFRCapability
   RegionCode
   RegionInfo
   SDIOManufacturerTuple
   SDIOProductInfo
   SerialNumber
   SIMTrayStatus
   SoftwareBehavior
   SoftwareBundleVersion
   SupportedDeviceFamilies
   SupportedKeyboards
   telephony
   UniqueChipID
   UniqueDeviceID
   UserAssignedDeviceName
   wifi
   WifiVendor
   */
  public func deviceInfo(forKey key: String) -> Any? {
    return perform(Selector(("_deviceInfoForKey:")), with: key)?.takeUnretainedValue()
  }

  public static var modelIdentifier: String {
    return sysctlMachine()
  }

  public static var modelName: String {
    return modelName(identifier: modelIdentifier)
  }

  /// - See: https://stackoverflow.com/a/26962452/11235826
  /// - See: https://gist.github.com/adamawolf/3048717
  /// - See: https://gist.github.com/Siguza/0331c183c8c59e4850cd0b62fd501424
  /// - See: https://appledb.dev/device/identifier/iPad8,11.html?filter=release for processor
  public static func modelName(identifier: String) -> String {
    switch identifier {
      /* iPhone */
    case "iPhone3,1":               return "iPhone 4" // GSM
    case "iPhone3,2":               return "iPhone 4" // GSM, 2012
    case "iPhone3,3":               return "iPhone 4" // Global

    case "iPhone4,1":               return "iPhone 4s"

    case "iPhone5,1":               return "iPhone 5" // GSM
    case "iPhone5,2":               return "iPhone 5" // Global
    case "iPhone5,3":               return "iPhone 5c" // GSM
    case "iPhone5,4":               return "iPhone 5c" // Global

    case "iPhone6,1":               return "iPhone 5s" // GSM
    case "iPhone6,2":               return "iPhone 5s" // Global

    case "iPhone7,1":               return "iPhone 6 Plus"
    case "iPhone7,2":               return "iPhone 6"

    case "iPhone8,1":               return "iPhone 6s"
    case "iPhone8,2":               return "iPhone 6s Plus"
    case "iPhone8,4":               return "iPhone SE"

    case "iPhone9,1":               return "iPhone 7" // Global
    case "iPhone9,2":               return "iPhone 7 Plus" // Global
    case "iPhone9,3":               return "iPhone 7" // GSM
    case "iPhone9,4":               return "iPhone 7 Plus" // GSM

    case "iPhone10,1":              return "iPhone 8" // Global
    case "iPhone10,2":              return "iPhone 8 Plus" // Global
    case "iPhone10,3":              return "iPhone X" // Global
    case "iPhone10,4":              return "iPhone 8" // GSM
    case "iPhone10,5":              return "iPhone 8 Plus" // GSM
    case "iPhone10,6":              return "iPhone X" // GSM

    case "iPhone11,2":              return "iPhone Xs"
    case "iPhone11,4":              return "iPhone Xs Max" // China
    case "iPhone11,6":              return "iPhone Xs Max"
    case "iPhone11,8":              return "iPhone XR"

    case "iPhone12,1":              return "iPhone 11"
    case "iPhone12,3":              return "iPhone 11 Pro"
    case "iPhone12,5":              return "iPhone 11 Pro Max"
    case "iPhone12,8":              return "iPhone SE (2nd generation)"

    case "iPhone13,1":              return "iPhone 12 mini"
    case "iPhone13,2":              return "iPhone 12"
    case "iPhone13,3":              return "iPhone 12 Pro"
    case "iPhone13,4":              return "iPhone 12 Pro Max"

    case "iPhone14,2":              return "iPhone 13 Pro"
    case "iPhone14,3":              return "iPhone 13 Pro Max"
    case "iPhone14,4":              return "iPhone 13 mini"
    case "iPhone14,5":              return "iPhone 13"
    case "iPhone14,6":              return "iPhone SE (3rd generation)"
    case "iPhone14,7":              return "iPhone 14"
    case "iPhone14,8":              return "iPhone 14 Plus"

    case "iPhone15,2":              return "iPhone 14 Pro"
    case "iPhone15,3":              return "iPhone 14 Pro Max"
    case "iPhone15,4":              return "iPhone 15"
    case "iPhone15,5":              return "iPhone 15 Plus"

    case "iPhone16,1":              return "iPhone 15 Pro"
    case "iPhone16,2":              return "iPhone 15 Pro Max"

    case "iPhone17,1":              return "iPhone 16 Pro"
    case "iPhone17,2":              return "iPhone 16 Pro Max"
    case "iPhone17,3":              return "iPhone 16"
    case "iPhone17,4":              return "iPhone 16 Plus"
    case "iPhone17,5":              return "iPhone 16e"


      /* iPod */
    case "iPod1,1":                 return "iPod touch"
    case "iPod2,1":                 return "iPod touch (2nd generation)"
    case "iPod3,1":                 return "iPod touch (3rd generation)"
    case "iPod4,1":                 return "iPod touch (4th generation)"
    case "iPod5,1":                 return "iPod touch (5th generation)"
    case "iPod7,1":                 return "iPod touch (6th generation)"
    case "iPod9,1":                 return "iPod touch (7th generation)"


      /* iPad */
    case "iPad2,1":                 return "iPad 2 (A5)" // WiFi
    case "iPad2,2":                 return "iPad 2 (A5)" // WiFi + GSM
    case "iPad2,3":                 return "iPad 2 (A5)" // WiFi + Global
    case "iPad2,4":                 return "iPad 2 (A5)" // WiFi, Mid-2012
    case "iPad2,5":                 return "iPad mini (A5)" // WiFi
    case "iPad2,6":                 return "iPad mini (A5)" // WiFi + GSM
    case "iPad2,7":                 return "iPad mini (A5)" // WiFi + Global

    case "iPad3,1":                 return "iPad (A5X) (3rd generation)" // WiFi
    case "iPad3,2":                 return "iPad (A5X) (3rd generation)" // WiFi + Global
    case "iPad3,3":                 return "iPad (A5X) (3rd generation)" // WiFi + GSM
    case "iPad3,4":                 return "iPad (A6X) (4th generation)" // WiFi
    case "iPad3,5":                 return "iPad (A6X) (4th generation)" // WiFi + GSM
    case "iPad3,6":                 return "iPad (A6X) (4th generation)" // WiFi + Global

    case "iPad4,1":                 return "iPad Air (A7)" // WiFi
    case "iPad4,2":                 return "iPad Air (A7)" // WiFi + Cellular
    case "iPad4,3":                 return "iPad Air (A7)" // WiFi + Cellular, China
    case "iPad4,4":                 return "iPad mini 2 (A7)" // WiFi
    case "iPad4,5":                 return "iPad mini 2 (A7)" // WiFi + Cellular
    case "iPad4,6":                 return "iPad mini 2 (A7)" // WiFi + Cellular, China
    case "iPad4,7":                 return "iPad mini 3 (A7)" // WiFi
    case "iPad4,8":                 return "iPad mini 3 (A7)" // WiFi + Cellular
    case "iPad4,9":                 return "iPad mini 3 (A7)" // WiFi + Cellular, China

    case "iPad5,1":                 return "iPad mini 4 (A8)" // WiFi
    case "iPad5,2":                 return "iPad mini 4 (A8)" // WiFi + Cellular
    case "iPad5,3":                 return "iPad Air 2 (A8X)" // WiFi
    case "iPad5,4":                 return "iPad Air 2 (A8X)" // WiFi + Cellular

    case "iPad6,3":                 return "iPad Pro (A9X) 9.7-inch" // WiFi
    case "iPad6,4":                 return "iPad Pro (A9X) 9.7-inch" // WiFi + Cellular
    case "iPad6,7":                 return "iPad Pro 12.9-inch (A9X) (1st generation)" // WiFi
    case "iPad6,8":                 return "iPad Pro 12.9-inch (A9X) (1st generation)" // WiFi + Cellular
    case "iPad6,11":                return "iPad (A9) (5th generation)" // WiFi
    case "iPad6,12":                return "iPad (A9) (5th generation)" // WiFi + Cellular

    case "iPad7,1":                 return "iPad Pro 12.9-inch (A10X) (2nd generation)" // WiFi
    case "iPad7,2":                 return "iPad Pro 12.9-inch (A10X) (2nd generation)" // WiFi + Cellular
    case "iPad7,3":                 return "iPad Pro 10.5-inch (A10X)" // WiFi
    case "iPad7,4":                 return "iPad Pro 10.5-inch (A10X)" // WiFi + Cellular
    case "iPad7,5":                 return "iPad (A10) (6th generation)" // 9.7-inch, WiFi
    case "iPad7,6":                 return "iPad (A10) (6th generation)" // 9.7-inch, WiFi + Cellular
    case "iPad7,11":                return "iPad (A10) (7th generation)" // 10.2-inch, WiFi
    case "iPad7,12":                return "iPad (A10) (7th generation)" // 10.2-inch, WiFi + Cellular

    case "iPad8,1":                 return "iPad Pro 11-inch (A12X) (1st generation)" // WiFi
    case "iPad8,2":                 return "iPad Pro 11-inch (A12X) (1st generation)" // WiFi, 1TB
    case "iPad8,3":                 return "iPad Pro 11-inch (A12X) (1st generation)" // WiFi + Cellular
    case "iPad8,4":                 return "iPad Pro 11-inch (A12X) (1st generation)" // WiFi + Cellular, 1TB
    case "iPad8,5":                 return "iPad Pro 12.9-inch (A12X) (3rd generation)" // WiFi
    case "iPad8,6":                 return "iPad Pro 12.9-inch (A12X) (3rd generation)" // WiFi, 1TB
    case "iPad8,7":                 return "iPad Pro 12.9-inch (A12X) (3rd generation)" // WiFi + Cellular
    case "iPad8,8":                 return "iPad Pro 12.9-inch (A12X) (3rd generation)" // WiFi + Cellular, 1TB
    case "iPad8,9":                 return "iPad Pro 11-inch (A12Z) (2nd generation)" // WiFi
    case "iPad8,10":                return "iPad Pro 11-inch (A12Z) (2nd generation)" // WiFi + Cellular
    case "iPad8,11":                return "iPad Pro 12.9-inch (A12Z) (4th generation)" // WiFi
    case "iPad8,12":                return "iPad Pro 12.9-inch (A12Z) (4th generation)" // WiFi + Cellular

    case "iPad11,1":                return "iPad mini (A12) (5th generation)" // WiFi
    case "iPad11,2":                return "iPad mini (A12) (5th generation)" // WiFi + Cellular
    case "iPad11,3":                return "iPad Air (A12) (3rd generation)" // WiFi
    case "iPad11,4":                return "iPad Air (A12) (3rd generation)" // WiFi + Cellular
    case "iPad11,6":                return "iPad (A12) (8th generation)" // WiFi
    case "iPad11,7":                return "iPad (A12) (8th generation)" // WiFi + Cellular

    case "iPad12,1":                return "iPad (A13) (9th generation)" // WiFi
    case "iPad12,2":                return "iPad (A13) (9th generation)" // WiFi + Cellular

    case "iPad13,1":                return "iPad Air (A14) (4th generation)" // WiFi
    case "iPad13,2":                return "iPad Air (A14) (4th generation)" // WiFi + Cellular
    case "iPad13,4":                return "iPad Pro 11-inch (M1) (3rd generation)" // WiFi
    case "iPad13,5":                return "iPad Pro 11-inch (M1) (3rd generation)" // WiFi + Cellular, US
    case "iPad13,6":                return "iPad Pro 11-inch (M1) (3rd generation)" // WiFi + Cellular, Global
    case "iPad13,7":                return "iPad Pro 11-inch (M1) (3rd generation)" // WiFi + Cellular, China
    case "iPad13,8":                return "iPad Pro 12.9-inch (M1) (5th generation)" // WiFi
    case "iPad13,9":                return "iPad Pro 12.9-inch (M1) (5th generation)" // WiFi + Cellular, US
    case "iPad13,10":               return "iPad Pro 12.9-inch (M1) (5th generation)" // WiFi + Cellular, Global
    case "iPad13,11":               return "iPad Pro 12.9-inch (M1) (5th generation)" // WiFi + Cellular, China
    case "iPad13,16":               return "iPad Air (M1) (5th generation)" // WiFi
    case "iPad13,17":               return "iPad Air (M1) (5th generation)" // WiFi + Cellular
    case "iPad13,18":               return "iPad (A14) (10th generation)" // WiFi
    case "iPad13,19":               return "iPad (A14) (10th generation)" // WiFi + Cellular

    case "iPad14,1":                return "iPad mini (A15) (6th generation)" // WiFi
    case "iPad14,2":                return "iPad mini (A15) (6th generation)" // WiFi + Cellular
    case "iPad14,3":                return "iPad Pro 11-inch (M2) (4th generation)" // WiFi
    case "iPad14,4":                return "iPad Pro 11-inch (M2) (4th generation)" // WiFi + Cellular
    case "iPad14,5":                return "iPad Pro 12.9-inch (M2) (6th generation)" // WiFi
    case "iPad14,6":                return "iPad Pro 12.9-inch (M2) (6th generation)" // WiFi + Cellular
    case "iPad14,8":                return "iPad Air 11-inch (M2) (6th generation)" // WiFi
    case "iPad14,9":                return "iPad Air 11-inch (M2) (6th generation)" // Cellular
    case "iPad14,10":               return "iPad Air 13-inch (M2) (6th generation)" // WiFi
    case "iPad14,11":               return "iPad Air 13-inch (M2) (6th generation)" // Cellular

    case "iPad15,3":                return "iPad Air 11-inch (M3) (7th generation)" // WiFi
    case "iPad15,4":                return "iPad Air 11-inch (M3) (7th generation)" // WiFi + Cellular
    case "iPad15,5":                return "iPad Air 13-inch (M3) (7th generation)" // WiFi
    case "iPad15,6":                return "iPad Air 13-inch (M3) (7th generation)" // WiFi + Cellular
    case "iPad15,7":                return "iPad (A16) (11th generation)" // WiFi
    case "iPad15,8":                return "iPad (A16) (11th generation)" // WiFi + Cellular

    case "iPad16,1":                return "iPad mini (A17 Pro) (7th generation)" // WiFi
    case "iPad16,2":                return "iPad mini (A17 Pro) (7th generation)" // WiFi + Cellular
    case "iPad16,3":                return "iPad Pro 11-inch (M4) (5th generation)"
    case "iPad16,4":                return "iPad Pro 11-inch (M4) (5th generation)"
    case "iPad16,5":                return "iPad Pro 13-inch (M4) (7th generation)"
    case "iPad16,6":                return "iPad Pro 13-inch (M4) (7th generation)"


      /* Apple TV */
    case "AppleTV1,1":              return "Apple TV" // Apple TV (1st generation)
    case "AppleTV2,1":              return "Apple TV (2nd generation)"
    case "AppleTV3,1":              return "Apple TV (3rd generation)" // (Early 2012)
    case "AppleTV3,2":              return "Apple TV (3rd generation)" // (Early 2013)
    case "AppleTV5,3":              return "Apple TV HD" // Previously Apple TV (4th generation)
    case "AppleTV6,2":              return "Apple TV 4K" // Apple TV 4K (1st generation)
    case "AppleTV11,1":             return "Apple TV 4K (2nd generation)"
    case "AppleTV14,1":             return "Apple TV 4K (3rd generation)"


      /* Apple Watch */
    case "Watch1,1":                return "Apple Watch, 38mm" // 1st generation or Series 0
    case "Watch1,2":                return "Apple Watch, 42mm" // 1st generation or Series 0

    case "Watch2,3":                return "Apple Watch Series 2, 38mm"
    case "Watch2,4":                return "Apple Watch Series 2, 42mm"
    case "Watch2,6":                return "Apple Watch Series 1, 38mm"
    case "Watch2,7":                return "Apple Watch Series 1, 42mm"

    case "Watch3,1":                return "Apple Watch Series 3, 38mm" // GPS + Cellular
    case "Watch3,2":                return "Apple Watch Series 3, 42mm" // GPS + Cellular
    case "Watch3,3":                return "Apple Watch Series 3, 38mm" // GPS
    case "Watch3,4":                return "Apple Watch Series 3, 42mm" // GPS

    case "Watch4,1":                return "Apple Watch Series 4, 40mm" // GPS
    case "Watch4,2":                return "Apple Watch Series 4, 44mm" // GPS
    case "Watch4,3":                return "Apple Watch Series 4, 40mm" // GPS + Cellular
    case "Watch4,4":                return "Apple Watch Series 4, 44mm" // GPS + Cellular

    case "Watch5,1":                return "Apple Watch Series 5, 40mm" // GPS
    case "Watch5,2":                return "Apple Watch Series 5, 44mm" // GPS
    case "Watch5,3":                return "Apple Watch Series 5, 40mm" // GPS + Cellular
    case "Watch5,4":                return "Apple Watch Series 5, 44mm" // GPS + Cellular

    case "Watch5,9":                return "Apple Watch SE, 40mm" // GPS
    case "Watch5,10":               return "Apple Watch SE, 44mm" // GPS
    case "Watch5,11":               return "Apple Watch SE, 40mm" // GPS + Cellular
    case "Watch5,12":               return "Apple Watch SE, 44mm" // GPS + Cellular

    case "Watch6,1":                return "Apple Watch Series 6, 40mm" // GPS
    case "Watch6,2":                return "Apple Watch Series 6, 44mm" // GPS
    case "Watch6,3":                return "Apple Watch Series 6, 40mm" // GPS + Cellular
    case "Watch6,4":                return "Apple Watch Series 6, 44mm" // GPS + Cellular

    case "Watch6,6":                return "Apple Watch Series 7, 41mm" // GPS
    case "Watch6,7":                return "Apple Watch Series 7, 45mm" // GPS
    case "Watch6,8":                return "Apple Watch Series 7, 41mm" // GPS + Cellular
    case "Watch6,9":                return "Apple Watch Series 7, 45mm" // GPS + Cellular

    case "Watch6,10":               return "Apple Watch SE (2nd generation), 40mm" // GPS
    case "Watch6,11":               return "Apple Watch SE (2nd generation), 44mm" // GPS
    case "Watch6,12":               return "Apple Watch SE (2nd generation), 40mm" // GPS + Cellular
    case "Watch6,13":               return "Apple Watch SE (2nd generation), 44mm" // GPS + Cellular

    case "Watch6,14":               return "Apple Watch Series 8, 41mm" // GPS
    case "Watch6,15":               return "Apple Watch Series 8, 45mm" // GPS
    case "Watch6,16":               return "Apple Watch Series 8, 41mm" // GPS + Cellular
    case "Watch6,17":               return "Apple Watch Series 8, 45mm" // GPS + Cellular
    case "Watch6,18":               return "Apple Watch Ultra"

    case "Watch7,1":                return "Apple Watch Series 9, 41mm" // GPS
    case "Watch7,2":                return "Apple Watch Series 9, 45mm" // GPS
    case "Watch7,3":                return "Apple Watch Series 9, 41mm" // GPS + Cellular
    case "Watch7,4":                return "Apple Watch Series 9, 45mm" // GPS + Cellular
    case "Watch7,5":                return "Apple Watch Ultra 2"

    case "Watch7,8":                return "Apple Watch Series 10, 42mm" // GPS
    case "Watch7,9":                return "Apple Watch Series 10, 46mm" // GPS
    case "Watch7,10":               return "Apple Watch Series 10, 42mm" // GPS + Cellular
    case "Watch7,11":               return "Apple Watch Series 10, 46mm" // GPS + Cellular

      /* HomePod */
    case "AudioAccessory1,1":       return "HomePod"
    case "AudioAccessory1,2":       return "HomePod" // Unknown
    case "AudioAccessory5,1":       return "HomePod mini"
    case "AudioAccessory6,1":       return "HomePod (2nd generation)"


      /* Mac */
    case "iMac21,1":                return "iMac 24-inch (M1, 2021)"
    case "iMac21,2":                return "iMac 24-inch (M1, 2021)"
    case "MacBookAir10,1":          return "MacBook Air (M1, 2020)"
    case "MacBookPro17,1":          return "MacBook Pro 13-inch (M1, 2020)"
    case "MacBookPro18,1":          return "MacBook Pro 16-inch (M1 Pro, 2021)"
    case "MacBookPro18,2":          return "MacBook Pro 16-inch (M1 Max, 2021)"
    case "MacBookPro18,3":          return "MacBook Pro 14-inch (M1 Pro, 2021)"
    case "MacBookPro18,4":          return "MacBook Pro 14-inch (M1 Max, 2021)"
    case "Macmini9,1":              return "Mac mini (M1, 2020)"
    case "Mac13,1":                 return "Mac Studio (M1 Max, 2022)"
    case "Mac13,2":                 return "Mac Studio (M1 Ultra, 2022)"
    case "Mac14,2":                 return "MacBook Air (M2, 2022)"
    case "Mac14,3":                 return "Mac mini (M2, 2023)"
    case "Mac14,5":                 return "MacBook Pro 14-inch (M2 Pro, 2023)"
    case "Mac14,6":                 return "MacBook Pro 16-inch (M2 Pro, 2023)"
    case "Mac14,7":                 return "MacBook Pro 13-inch (M2, 2022)"
    case "Mac14,8":                 return "Mac mini (M3, 2023)"
    case "Mac14,9":                 return "MacBook Pro 14-inch (M2 Max, 2023)"
    case "Mac14,10":                return "MacBook Pro 16-inch (M2 Max, 2023)"
    case "Mac14,12":                return "Mac mini (M2 Pro, 2023)"
    case "Mac14,13":                return "Mac Studio (M2 Max, 2023)"
    case "Mac14,14":                return "Mac Studio (M2 Ultra, 2023)"
    case "Mac15,1":                 return "MacBook Pro 16-inch (M3 Pro, 2023)"
    case "Mac15,2":                 return "MacBook Pro 16-inch (M3 Max, 2023)"
    case "Mac15,3":                 return "MacBook Pro 14-inch (M3 Pro, 2023)"
    case "Mac15,4":                 return "MacBook Pro 14-inch (M3 Max, 2023)"
    case "Mac15,5":                 return "iMac 24-inch (M3, 2023)"
    case "Mac15,12":                return "MacBook Air (M3, 2024)"
    case "Mac15,13":                return "MacBook Air (M3, 2024)"


      /* Simulator */
    case "i386", "x86_64", "arm64":
      if ProcessInfo.processInfo.isOnMac {
        let modelIdentifier = sysctlModel()
        return modelName(identifier: modelIdentifier)
      } else {
        if let simulatorModelIdentifier = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] {
          return "\(modelName(identifier: simulatorModelIdentifier)) Simulator"
        } else {
          return identifier
        }
      }


    default:
      return identifier
    }
  }
}

extension ProcessInfo {

  public var isOnMac: Bool {
    if #available(iOS 14.0, *) {
      if isiOSAppOnMac || isMacCatalystApp {
        return true
      }
    } else if #available(iOS 13.0, *) {
      if isMacCatalystApp {
        return true
      }
    }
    return false
  }
}
