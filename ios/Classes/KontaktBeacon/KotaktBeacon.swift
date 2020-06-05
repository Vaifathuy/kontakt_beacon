//
//  KotaktBeacon.swift
//  Runner
//
//  Created by Vaifat on 6/3/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter
import KontaktSDK

class KontaktBeacon: NSObject{
    static var instance: KontaktBeacon = KontaktBeacon()
    fileprivate var eddyStoneManager: KTKEddystoneManager!
    
    // MARK: Closures:
    var eddyStoneDidFailToStart: ((_ manager: KTKEddystoneManager, _ error: Error?) -> Void)!
    var eddyStoneDidDiscover: ((_ manager: KTKEddystoneManager, _ eddystones: Set<KTKEddystone>, _ region: KTKEddystoneRegion?) -> Void)!
    var eddyStoneDidUpdate: ((_ manager: KTKEddystoneManager, _ eddystone: KTKEddystone, _ frameType: KTKEddystoneFrameType) -> Void)!
    
    // Constructor
    override init() {
        super.init()
        setupBeaconManager()
    }
    
    fileprivate func setupBeaconManager(){
        eddyStoneManager = KTKEddystoneManager(delegate: self)
    }
}

// Helper functions
extension KontaktBeacon {
    /// "startMonitoringBeacon"
    /// - Parameter beaconRegion: region to start monitoring
    func startMonitoringEddyStone(for beaconRegion: KTKEddystoneRegion? = nil){
        eddyStoneManager.startEddystoneDiscovery(in: beaconRegion)
    }
    
    func checkBluetoothStatus() -> CBManagerState {
        return eddyStoneManager.centralState
    }
    
    func translateProximity(proximity: CLProximity) -> String {
        switch proximity {
        case .unknown:
            return "Unknown"
        case .immediate:
            return "Very near"
        case .near:
            return "Near"
        case .far:
            return "Far"
        default:
            return "N/A"
        }
    }
}

extension KontaktBeacon: KTKEddystoneManagerDelegate {
    func eddystoneManager(_ manager: KTKEddystoneManager, didDiscover eddystones: Set<KTKEddystone>, in region: KTKEddystoneRegion?) {
        eddyStoneDidDiscover(manager, eddystones, region)
    }
    
    func eddystoneManagerDidFail(toStartDiscovery manager: KTKEddystoneManager, withError error: Error?) {
        eddyStoneDidFailToStart(manager, error)
    }
    
    func eddystoneManager(_ manager: KTKEddystoneManager, didUpdate eddystone: KTKEddystone, with frameType: KTKEddystoneFrameType) {
        eddyStoneDidUpdate(manager, eddystone, frameType)
    }
}
