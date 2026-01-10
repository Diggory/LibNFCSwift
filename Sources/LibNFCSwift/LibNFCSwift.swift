//  Swift Library wrapping libNFC C library

import Clibnfc


public struct NFC {

    /// Print the libNFC version
    public func printLibNFCVersion() {
        print("libNFC version: \(nfc_version())")
    }
}
