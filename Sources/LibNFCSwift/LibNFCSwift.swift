//  Swift Library wrapping libNFC C library

import Clibnfc


public class NFC {

    /// `nfc_context` that the C API uses to keep a reference to the instance
    var nfcContext: OpaquePointer?
    ///  an NFC hardware device that we connect to.
    var nfcDevice: OpaquePointer?

    public init() {}

    /// Clean-up
    deinit {
        if nfcDevice != nil {
            //  Close the device?
            nfc_close(nfcDevice)
            nfcDevice = nil
        }

        if nfcContext != nil {
            //  clean-up / release the context
            nfc_exit(nfcContext!)
            nfcContext = nil
        }
    }

    /// The libNFC version as a string
    public func libNFCVersion() -> String? {
        if let versionString = nfc_version() {
            let swiftString = String(cString: versionString)
            return swiftString
        } else {
            print("Unable to get libNFC version as Swift String")
            return nil
        }
    }

    /// Startup the NFC instance
    public func nfcInit() {
        guard nfcContext == nil else {
            print("attempt to nfc_init(), but it has already been initialized")
            return
        }
        nfc_init(&nfcContext)
        if nfcContext == nil {
            print("nfc_init() returned nil")
        }
    }

    /// Open connection to the NFC hardware
    public func nfcOpen() {
        guard let nfcContext else {
            print("nfc_open() called before nfc_init()")
            return
        }
        /// 2nd param: A connection string that specifies which device to open. If NULL, the first available device is used
        nfcDevice = nfc_open(nfcContext, nil)
        guard nfcDevice != nil else {
            print("was not able to open the nfc device")
            return
        }


    }

    /// Name of the NFC hardware device
    public func deviceName() -> String? {
        guard let nfcDevice else {
            print("nfc_device_get_name() called before nfc_open()")
            return nil
        }
        guard let name = nfc_device_get_name(nfcDevice) else {
            print("unable to get the device name")
            return nil
        }
        //        return "Device name goes here!"
        let swiftName = String(cString: name)
        return swiftName
    }
}
