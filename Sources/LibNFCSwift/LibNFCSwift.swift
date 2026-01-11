//  Swift Library wrapping libNFC C library

import Clibnfc

public class NFC {

    public class Device {
        let nfc: NFC
        ///  an NFC hardware device that we connect to.
        let nfcDevice: OpaquePointer?

        /// Internal name storage, not for public use.
        var _name: String?

        /// Name of NFC hardware, from the device itself.
        public var name: String {
            if _name != nil {
                return _name!
            }
            _name = self.nfcDeviceName() ?? "Name not available"
            return _name!
        }

        public init(nfc: NFC, nfcDevice: OpaquePointer) {
            self.nfc = nfc
            self.nfcDevice = nfcDevice
        }

        /// Required clean-up for libnfc
        deinit {
            if nfcDevice != nil {
                //  Close the device
                print("closing nfcDevice in its own deinit() method")
                nfc_close(nfcDevice)
            }
        }

        /// Name of the NFC hardware device, gathered from libnfc
        func nfcDeviceName() -> String? {
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

        /// Close the device
        public func close() {
            //  call back to NFC context to close the device.
            //  FIXME: Device is not removed from the NFC.devices array…
            print("NFC.Device.close()")
            nfc_close(nfcDevice)
        }

        /// Start in initiator mode
        public func nfcInitiator() throws {
            let error = NFCError(rawValue: Int(nfc_initiator_init(nfcDevice)))
            guard error == .success else {
                print("Error starting in initiator mode: \(error!)")
                throw error!
            }
        }
    }

    /// `nfc_context` that the C API uses to keep a reference to the instance
    var nfcContext: OpaquePointer?
    public var devices: [Device] = []

    public init() {
        nfcInit()
    }

    /// Clean-up
    deinit {
        print("NFC.deinit()")
        //  Close all the devices
        for device in devices {
            device.close()
        }

        if nfcContext != nil {
            //  clean-up / release the context
            print("nfc_exit()")
            nfc_exit(nfcContext!)
            nfcContext = nil
        }
    }

    //MARK: - libnfc function wrappers

    /// Startup the NFC instance
    func nfcInit() {
        guard nfcContext == nil else {
            print("attempt to nfc_init(), but it has already been initialized")
            return
        }
        nfc_init(&nfcContext)
        if nfcContext == nil {
            print("nfc_init() returned nil")
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


    /// Open connection to the NFC hardware
    public func nfcOpen() -> Result<NFC.Device, NFCError.Open> {

        guard let nfcContext else {
            return .failure(.nfcNotInitialised)
        }

        var nfcDevice: OpaquePointer?
        /// 2nd param: A connection string that specifies which device to open. If NULL, the first available device is used
        nfcDevice = nfc_open(nfcContext, nil)

        guard nfcDevice != nil else {
            return .failure(.couldNotOpenDevice)
        }

        let openedDevice = NFC.Device(nfc: self, nfcDevice: nfcDevice!)
        devices.append(openedDevice)
        return .success(openedDevice)
    }


    /*

     printf("NFC device will poll during %ld ms (%u pollings of %lu ms for %" PRIdPTR " modulations)\n", (unsigned long) uiPollNr * szModulations * uiPeriod * 150, uiPollNr, (unsigned long) uiPeriod * 150, szModulations);
     if ((res = nfc_initiator_poll_target(pnd, nmModulations, szModulations, uiPollNr, uiPeriod, &nt))  < 0) {
       nfc_perror(pnd, "nfc_initiator_poll_target");
       nfc_close(pnd);
       nfc_exit(context);
       exit(EXIT_FAILURE);
     }

     if (res > 0) {
       print_nfc_target(&nt, verbose);
       printf("Waiting for card removing...");
       fflush(stdout);
       while (0 == nfc_initiator_target_is_present(pnd, NULL)) {}
       nfc_perror(pnd, "nfc_initiator_target_is_present");
       printf("done.\n");
     } else {
       printf("No target found.\n");
     }

     nfc_close(pnd);

     */


    public func basicPollTest(device: NFC.Device) {

        let modulations = [
            nfc_modulation(nmt: NMT_ISO14443A, nbr: NBR_106),
            nfc_modulation(nmt: NMT_ISO14443B, nbr: NBR_106),
            nfc_modulation(nmt: NMT_FELICA, nbr: NBR_212),
            nfc_modulation(nmt: NMT_FELICA, nbr: NBR_424),
            nfc_modulation(nmt: NMT_JEWEL, nbr: NBR_106),
            nfc_modulation(nmt: NMT_ISO14443BICLASS, nbr: NBR_106),
        ]

        let uiPollNr = 20
        let uiPeriod = 2
        let szModulations = 6

        var nt: nfc_target = nfc_target()

        print("NFC device will poll during \(uiPollNr * szModulations * uiPeriod * 150) ms (\(uiPollNr) pollings of \(uiPeriod * 150) ms for \(szModulations) modulations)")

//        nfc_initiator_poll_target()
        let res = Int(nfc_initiator_poll_target(device.nfcDevice, modulations, szModulations, UInt8(uiPollNr), UInt8(uiPeriod), &nt))

        if res < 0 {
            if let error = NFCError(rawValue: res) {
                print("Error polling: \(error)")
            } else {
                print("Unknown error polling…")
            }
            return
        }
        print("Poll result: \(res)")
        print("target: \(nt)")



    }

}
