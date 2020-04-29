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
  final public func deviceInfo<T>(forKey key: String) -> T? {
    return performIfResponds(Selector(("_deviceInfoForKey:")), with: key as NSString)?.takeUnretainedValue() as? T
  }
}
#endif
