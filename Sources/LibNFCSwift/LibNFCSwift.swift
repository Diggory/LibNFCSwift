//  Swift Library wrapping libNFC C library

import Clibnfc


public struct NFC {
    public func printLibNFCVersion() {
        print("libNFC version: \(nfc_version())")
    }
}
