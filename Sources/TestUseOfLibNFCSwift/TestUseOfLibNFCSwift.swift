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
        print ("LibNFC version \(nfc.libNFCVersion() ?? "Version not available")")

        let result = nfc.nfcOpen()
        switch result {
        case .failure(let error):
            print("Error attempting to open NFC device: \(error)")
            return
        case .success(let device):
            print("NFC Device name: \(device.name)")
        }


        do {
            print("Attempting to start initiator mode…")
            try  nfc.devices.first?.nfcInitiator()
            
        } catch {
            print("Could not start initiator mode: \(error)")
        }

    }
}
