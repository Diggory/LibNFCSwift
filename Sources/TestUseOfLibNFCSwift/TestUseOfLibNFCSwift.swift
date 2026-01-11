//
//  TestUseOfLibNFCSwift.swift
//  LibNFCSwift
//
//  Created by Diggory Laycock on 11/01/2026.
//

import LibNFCSwift

@main
struct TestUseOfLibNFCSwift {
    static func main() -> Void {
        let nfc = NFC()
//        var tmpDevice: NFC.Device?
        let device: NFC.Device

        print ("LibNFC version \(nfc.libNFCVersion() ?? "Version not available")")

        //  Open NFC
        let result = nfc.nfcOpen()
        switch result {
        case .failure(let error):
            print("Error attempting to open NFC device: \(error)")
            return
        case .success(let dev):
            print("NFC Device name: \(dev.name)")
            device = dev
        }


        //  Start Initiator mode
        do {
            print("Attempting to start initiator mode…")
            try  device.nfcInitiator()
        } catch {
            print("Could not start initiator mode: \(error)")
            return
        }

        nfc.basicPollTest(device: device)


    }
}
