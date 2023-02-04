//
//  UIDevice.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)
import UIKit

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

  public static var modelIdentifier: String? {
    var systemInfo = utsname()
    uname(&systemInfo)
    return withUnsafePointer(to: &systemInfo.machine) {
      $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
        String(validatingUTF8: ptr)
      }
    }
  }

  public static var modelName: String? {
    return modelIdentifier.map(modelName(identifier:))
  }

  /// - See: https://stackoverflow.com/a/26962452/11235826
  /// - See: https://gist.github.com/adamawolf/3048717
  /// - See: https://gist.github.com/Siguza/0331c183c8c59e4850cd0b62fd501424
  public static func modelName(identifier: String) -> String {
    switch identifier {
      /* iPhone */
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":              return "iPhone 4"
    case "iPhone4,1":                                        return "iPhone 4s"
    case "iPhone5,1", "iPhone5,2":                           return "iPhone 5"
    case "iPhone5,3", "iPhone5,4":                           return "iPhone 5c"
    case "iPhone6,1", "iPhone6,2":                           return "iPhone 5s"
    case "iPhone7,2":                                        return "iPhone 6"
    case "iPhone7,1":                                        return "iPhone 6 Plus"
    case "iPhone8,1":                                        return "iPhone 6s"
    case "iPhone8,2":                                        return "iPhone 6s Plus"
    case "iPhone9,1", "iPhone9,3":                           return "iPhone 7"
    case "iPhone9,2", "iPhone9,4":                           return "iPhone 7 Plus"
    case "iPhone10,1", "iPhone10,4":                         return "iPhone 8"
    case "iPhone10,2", "iPhone10,5":                         return "iPhone 8 Plus"
    case "iPhone10,3", "iPhone10,6":                         return "iPhone X"
    case "iPhone11,2":                                       return "iPhone Xs"
    case "iPhone11,4", "iPhone11,6":                         return "iPhone Xs Max"
    case "iPhone11,8":                                       return "iPhone XR"
    case "iPhone12,1":                                       return "iPhone 11"
    case "iPhone12,3":                                       return "iPhone 11 Pro"
    case "iPhone12,5":                                       return "iPhone 11 Pro Max"
    case "iPhone13,1":                                       return "iPhone 12 mini"
    case "iPhone13,2":                                       return "iPhone 12"
    case "iPhone13,3":                                       return "iPhone 12 Pro"
    case "iPhone13,4":                                       return "iPhone 12 Pro Max"
    case "iPhone14,4":                                       return "iPhone 13 mini"
    case "iPhone14,5":                                       return "iPhone 13"
    case "iPhone14,2":                                       return "iPhone 13 Pro"
    case "iPhone14,3":                                       return "iPhone 13 Pro Max"
    case "iPhone14,7":                                       return "iPhone 14"
    case "iPhone14,8":                                       return "iPhone 14 Plus"
    case "iPhone15,2":                                       return "iPhone 14 Pro"
    case "iPhone15,3":                                       return "iPhone 14 Pro Max"
    case "iPhone8,4":                                        return "iPhone SE"
    case "iPhone12,8":                                       return "iPhone SE (2nd generation)"
    case "iPhone14,6":                                       return "iPhone SE (3rd generation)"

      /* iPod */
    case "iPod1,1":                                          return "iPod touch"
    case "iPod2,1":                                          return "iPod touch (2nd generation)"
    case "iPod3,1":                                          return "iPod touch (3rd generation)"
    case "iPod4,1":                                          return "iPod touch (4th generation)"
    case "iPod5,1":                                          return "iPod touch (5th generation)"
    case "iPod7,1":                                          return "iPod touch (6th generation)"
    case "iPod9,1":                                          return "iPod touch (7th generation)"

      /* iPad */
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":         return "iPad 2"
    case "iPad3,1", "iPad3,2", "iPad3,3":                    return "iPad (3rd generation)"
    case "iPad3,4", "iPad3,5", "iPad3,6":                    return "iPad (4th generation)"
    case "iPad6,11", "iPad6,12":                             return "iPad (5th generation)"
    case "iPad7,5", "iPad7,6":                               return "iPad (6th generation)"
    case "iPad7,11", "iPad7,12":                             return "iPad (7th generation)"
    case "iPad11,6", "iPad11,7":                             return "iPad (8th generation)"
    case "iPad12,1", "iPad12,2":                             return "iPad (9th generation)"
    case "iPad13,18", "iPad13,19":                           return "iPad (10th generation)"
    case "iPad4,1", "iPad4,2", "iPad4,3":                    return "iPad Air"
    case "iPad5,3", "iPad5,4":                               return "iPad Air 2"
    case "iPad11,3", "iPad11,4":                             return "iPad Air (3rd generation)"
    case "iPad13,1", "iPad13,2":                             return "iPad Air (4th generation)"
    case "iPad13,16", "iPad13,17":                           return "iPad Air (5th generation)"
    case "iPad2,5", "iPad2,6", "iPad2,7":                    return "iPad mini"
    case "iPad4,4", "iPad4,5", "iPad4,6":                    return "iPad mini 2"
    case "iPad4,7", "iPad4,8", "iPad4,9":                    return "iPad mini 3"
    case "iPad5,1", "iPad5,2":                               return "iPad mini 4"
    case "iPad11,1", "iPad11,2":                             return "iPad mini (5th generation)"
    case "iPad14,1", "iPad14,2":                             return "iPad mini (6th generation)"
    case "iPad6,3", "iPad6,4":                               return "iPad Pro (9.7-inch)"
    case "iPad7,3", "iPad7,4":                               return "iPad Pro (10.5-inch)"
    case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":         return "iPad Pro (11-inch) (1st generation)"
    case "iPad8,9", "iPad8,10":                              return "iPad Pro (11-inch) (2nd generation)"
    case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":     return "iPad Pro (11-inch) (3rd generation)"
    case "iPad14,3", "iPad14,4":                             return "iPad Pro (11-inch) (4th generation)"
    case "iPad6,7", "iPad6,8":                               return "iPad Pro (12.9-inch) (1st generation)"
    case "iPad7,1", "iPad7,2":                               return "iPad Pro (12.9-inch) (2nd generation)"
    case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":         return "iPad Pro (12.9-inch) (3rd generation)"
    case "iPad8,11", "iPad8,12":                             return "iPad Pro (12.9-inch) (4th generation)"
    case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":   return "iPad Pro (12.9-inch) (5th generation)"
    case "iPad14,5", "iPad14,6":                             return "iPad Pro (12.9-inch) (6th generation)"

      /* Apple TV */
    case "AppleTV1,1":                                       return "Apple TV" // Apple TV (1st generation)
    case "AppleTV2,1":                                       return "Apple TV (2nd generation)"
    case "AppleTV3,1", "AppleTV3,2":                         return "Apple TV (3rd generation)"
    case "AppleTV5,3":                                       return "Apple TV HD" // Previously Apple TV (4th generation)
    case "AppleTV6,2":                                       return "Apple TV 4K" // Apple TV 4K (1st generation)
    case "AppleTV11,1":                                      return "Apple TV 4K (2nd generation)"
    case "AppleTV14,1":                                      return "Apple TV 4K (3rd generation)"

      /* Apple Watch */
    case "Watch1,1", "Watch1,2":                             return "Apple Watch" // 1st generation or Series 0
    case "Watch2,6", "Watch2,7":                             return "Apple Watch Series 1"
    case "Watch2,3", "Watch2,4":                             return "Apple Watch Series 2"
    case "Watch3,1", "Watch3,2", "Watch3,3", "Watch3,4":     return "Apple Watch Series 3"
    case "Watch4,1", "Watch4,2", "Watch4,3", "Watch4,4":     return "Apple Watch Series 4"
    case "Watch5,1", "Watch5,2", "Watch5,3", "Watch5,4":     return "Apple Watch Series 5"
    case "Watch5,9", "Watch5,10", "Watch5,11", "Watch5,12":  return "Apple Watch SE"
    case "Watch6,1", "Watch6,2", "Watch6,3", "Watch6,4":     return "Apple Watch Series 6"
    case "Watch6,6", "Watch6,7", "Watch6,8", "Watch6,9":     return "Apple Watch Series 7"
    case "Watch6,10", "Watch6,11", "Watch6,12", "Watch6,13": return "Apple Watch SE (2nd generation)"
    case "Watch6,14", "Watch6,15", "Watch6,16", "Watch6,17": return "Apple Watch Series 8"
    case "Watch6,18":                                        return "Apple Watch Ultra"

      /* HomePod */
    case "AudioAccessory1,1":                                return "HomePod"
    case "AudioAccessory1,2":                                return "HomePod" // Unknown
    case "AudioAccessory5,1":                                return "HomePod mini"
    case "AudioAccessory6,1":                                return "HomePod (2nd generation)"

      /* Simulator */
    case "i386", "x86_64", "arm64":                          return "Simulator \(modelName(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!))"

    default:                                                 return identifier
    }
  }
}
#endif
