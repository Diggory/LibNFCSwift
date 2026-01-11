//
//  NFCTypes.swift
//  LibNFCSwift
//
//  Created by Diggory Laycock on 11/01/2026.
//

import Foundation
import Clibnfc

// MARK: - Baud Rate

/// Swift wrapper for NFC baud rate
enum BaudRate {
    case undefined
    case baud106
    case baud212
    case baud424
    case baud847

    init(_ cRate: nfc_baud_rate) {
        switch cRate {
        case NBR_UNDEFINED: self = .undefined
        case NBR_106: self = .baud106
        case NBR_212: self = .baud212
        case NBR_424: self = .baud424
        case NBR_847: self = .baud847
        default: self = .undefined
        }
    }

    var cValue: nfc_baud_rate {
        switch self {
        case .undefined: return NBR_UNDEFINED
        case .baud106: return NBR_106
        case .baud212: return NBR_212
        case .baud424: return NBR_424
        case .baud847: return NBR_847
        }
    }
}

// MARK: - Modulation Type

/// Swift wrapper for NFC modulation type
enum ModulationType {
    case iso14443a
    case jewel
    case iso14443b
    case iso14443bi
    case iso14443b2sr
    case iso14443b2ct
    case felica
    case dep
    case barcode
    case iso14443biclass

    init(_ cType: nfc_modulation_type) {
        switch cType {
        case NMT_ISO14443A: self = .iso14443a
        case NMT_JEWEL: self = .jewel
        case NMT_ISO14443B: self = .iso14443b
        case NMT_ISO14443BI: self = .iso14443bi
        case NMT_ISO14443B2SR: self = .iso14443b2sr
        case NMT_ISO14443B2CT: self = .iso14443b2ct
        case NMT_FELICA: self = .felica
        case NMT_DEP: self = .dep
        case NMT_BARCODE: self = .barcode
        case NMT_ISO14443BICLASS: self = .iso14443biclass
        default: self = .iso14443a
        }
    }

    var cValue: nfc_modulation_type {
        switch self {
        case .iso14443a: return NMT_ISO14443A
        case .jewel: return NMT_JEWEL
        case .iso14443b: return NMT_ISO14443B
        case .iso14443bi: return NMT_ISO14443BI
        case .iso14443b2sr: return NMT_ISO14443B2SR
        case .iso14443b2ct: return NMT_ISO14443B2CT
        case .felica: return NMT_FELICA
        case .dep: return NMT_DEP
        case .barcode: return NMT_BARCODE
        case .iso14443biclass: return NMT_ISO14443BICLASS
        }
    }

    var description: String {
        switch self {
        case .iso14443a: return "ISO14443A"
        case .jewel: return "Jewel"
        case .iso14443b: return "ISO14443B"
        case .iso14443bi: return "ISO14443BI"
        case .iso14443b2sr: return "ISO14443B-2 SR"
        case .iso14443b2ct: return "ISO14443B-2 CT"
        case .felica: return "FeliCa"
        case .dep: return "DEP"
        case .barcode: return "Barcode"
        case .iso14443biclass: return "ISO14443B iClass"
        }
    }
}

// MARK: - Mode

/// Swift wrapper for NFC mode
enum NFCMode {
    case target
    case initiator

    init(_ cMode: nfc_mode) {
        switch cMode {
        case N_TARGET: self = .target
        case N_INITIATOR: self = .initiator
        default: self = .target
        }
    }

    var cValue: nfc_mode {
        switch self {
        case .target: return N_TARGET
        case .initiator: return N_INITIATOR
        }
    }
}

// MARK: - Target Info

/// Swift wrapper for NFC target info union
struct TargetInfo {
    private var cInfo: nfc_target_info
    let modulationType: ModulationType

    init(_ info: nfc_target_info, modulationType: ModulationType) {
        self.cInfo = info
        self.modulationType = modulationType
    }

    var cValue: nfc_target_info {
        return cInfo
    }

    // Type-safe accessors based on modulation type
    var iso14443aInfo: nfc_iso14443a_info? {
        guard modulationType == .iso14443a else { return nil }
        return cInfo.nai
    }

    var felicaInfo: nfc_felica_info? {
        guard modulationType == .felica else { return nil }
        return cInfo.nfi
    }

    var iso14443bInfo: nfc_iso14443b_info? {
        guard modulationType == .iso14443b else { return nil }
        return cInfo.nbi
    }

    var iso14443biInfo: nfc_iso14443bi_info? {
        guard modulationType == .iso14443bi else { return nil }
        return cInfo.nii
    }

    var iso14443b2srInfo: nfc_iso14443b2sr_info? {
        guard modulationType == .iso14443b2sr else { return nil }
        return cInfo.nsi
    }

    var iso14443b2ctInfo: nfc_iso14443b2ct_info? {
        guard modulationType == .iso14443b2ct else { return nil }
        return cInfo.nci
    }

    var jewelInfo: nfc_jewel_info? {
        guard modulationType == .jewel else { return nil }
        return cInfo.nji
    }

    var depInfo: nfc_dep_info? {
        guard modulationType == .dep else { return nil }
        return cInfo.ndi
    }

    var barcodeInfo: nfc_barcode_info? {
        guard modulationType == .barcode else { return nil }
        return cInfo.nti
    }

    var iclassInfo: nfc_iso14443biclass_info? {
        guard modulationType == .iso14443biclass else { return nil }
        return cInfo.nhi
    }
}

// MARK: - Modulation

/// Swift wrapper for NFC modulation
struct Modulation {
    let type: ModulationType
    let baudRate: BaudRate

    init(type: ModulationType, baudRate: BaudRate) {
        self.type = type
        self.baudRate = baudRate
    }

    init(_ cModulation: nfc_modulation) {
        self.type = ModulationType(cModulation.nmt)
        self.baudRate = BaudRate(cModulation.nbr)
    }

    var cValue: nfc_modulation {
        return nfc_modulation(nmt: type.cValue, nbr: baudRate.cValue)
    }

    var description: String {
        return "\(type.description) @ \(baudRate)"
    }
}

extension BaudRate: CustomStringConvertible {
    var description: String {
        switch self {
        case .undefined: return "Undefined"
        case .baud106: return "106 kbps"
        case .baud212: return "212 kbps"
        case .baud424: return "424 kbps"
        case .baud847: return "847 kbps"
        }
    }
}

// MARK: - Target

/// Swift wrapper for NFC target
struct NFCTarget {
    let info: TargetInfo
    let modulation: Modulation

    init(info: TargetInfo, modulation: Modulation) {
        self.info = info
        self.modulation = modulation
    }

    init(_ cTarget: nfc_target) {
        self.modulation = Modulation(cTarget.nm)
        self.info = TargetInfo(cTarget.nti, modulationType: modulation.type)
    }

    var cValue: nfc_target {
        return nfc_target(nti: info.cValue, nm: modulation.cValue)
    }

    var description: String {
        return "NFC Target: \(modulation.description)"
    }
}

// MARK: - Convenience Extensions

extension NFCTarget {
    /// Returns true if this is an ISO14443A target
    var isISO14443A: Bool {
        return modulation.type == .iso14443a
    }

    /// Returns true if this is a FeliCa target
    var isFeliCa: Bool {
        return modulation.type == .felica
    }

    /// Returns true if this is an ISO14443B target
    var isISO14443B: Bool {
        return modulation.type == .iso14443b
    }
}

extension Modulation {
    /// Common modulation presets
    static let iso14443a106 = Modulation(type: .iso14443a, baudRate: .baud106)
    static let felica212 = Modulation(type: .felica, baudRate: .baud212)
    static let felica424 = Modulation(type: .felica, baudRate: .baud424)
    static let iso14443b106 = Modulation(type: .iso14443b, baudRate: .baud106)
}



// MARK: - ISO14443A Info

/// Swift wrapper for NFC ISO14443A tag (MIFARE) information
struct ISO14443AInfo {
    /// ATQA (Answer To reQuest type A) - 2 bytes
    let atqa: (UInt8, UInt8)

    /// SAK (Select AcKnowledge)
    let sak: UInt8

    /// UID (Unique Identifier) - variable length up to 10 bytes
    let uid: Data

    /// ATS (Answer To Select) - variable length up to 254 bytes
    let ats: Data

    init(atqa: (UInt8, UInt8), sak: UInt8, uid: Data, ats: Data = Data()) {
        self.atqa = atqa
        self.sak = sak
        self.uid = uid.prefix(10) // Ensure max 10 bytes
        self.ats = ats.prefix(254) // Ensure max 254 bytes
    }

    init(_ cInfo: nfc_iso14443a_info) {
        self.atqa = (cInfo.abtAtqa.0, cInfo.abtAtqa.1)
        self.sak = cInfo.btSak

        // Convert UID from fixed array to Data
        let uidBytes = withUnsafeBytes(of: cInfo.abtUid) { buffer in
            Array(buffer.prefix(Int(cInfo.szUidLen)))
        }
        self.uid = Data(uidBytes)

        // Convert ATS from fixed array to Data
        let atsBytes = withUnsafeBytes(of: cInfo.abtAts) { buffer in
            Array(buffer.prefix(Int(cInfo.szAtsLen)))
        }
        self.ats = Data(atsBytes)
    }

    var cValue: nfc_iso14443a_info {
        var info = nfc_iso14443a_info()

        // Set ATQA
        info.abtAtqa.0 = atqa.0
        info.abtAtqa.1 = atqa.1

        // Set SAK
        info.btSak = sak

        // Set UID
        info.szUidLen = min(uid.count, 10)
        uid.withUnsafeBytes { buffer in
            let bound = min(buffer.count, 10)
            withUnsafeMutableBytes(of: &info.abtUid) { dest in
                dest.copyBytes(from: buffer.prefix(bound))
            }
        }

        // Set ATS
        info.szAtsLen = min(ats.count, 254)
        ats.withUnsafeBytes { buffer in
            let bound = min(buffer.count, 254)
            withUnsafeMutableBytes(of: &info.abtAts) { dest in
                dest.copyBytes(from: buffer.prefix(bound))
            }
        }

        return info
    }
}

// MARK: - Computed Properties

extension ISO14443AInfo {
    /// UID length in bytes
    var uidLength: Int {
        return uid.count
    }

    /// ATS length in bytes
    var atsLength: Int {
        return ats.count
    }

    /// UID type based on length
    var uidType: UIDType {
        switch uid.count {
        case 4: return .single
        case 7: return .double
        case 10: return .triple
        default: return .unknown
        }
    }

    /// Check if ATS is present
    var hasATS: Bool {
        return !ats.isEmpty
    }

    /// ATQA as a 16-bit value (big-endian)
    var atqaValue: UInt16 {
        return (UInt16(atqa.0) << 8) | UInt16(atqa.1)
    }
}

// MARK: - UID Type

extension ISO14443AInfo {
    enum UIDType {
        case single   // 4 bytes
        case double   // 7 bytes
        case triple   // 10 bytes
        case unknown

        var description: String {
            switch self {
            case .single: return "Single (4 bytes)"
            case .double: return "Double (7 bytes)"
            case .triple: return "Triple (10 bytes)"
            case .unknown: return "Unknown"
            }
        }
    }
}

// MARK: - Card Type Detection

extension ISO14443AInfo {
    /// Detected card type based on SAK value
    var cardType: CardType {
        switch sak {
        case 0x00: return .mifareUltralight
        case 0x08: return .mifareClassic1K
        case 0x09: return .mifareClassicMini
        case 0x18: return .mifareClassic4K
        case 0x20: return .mifareDesfire
        case 0x28: return .jcopCard
        case 0x88: return .infineonCard
        default: return .unknown(sak: sak)
        }
    }

    enum CardType {
        case mifareUltralight
        case mifareClassic1K
        case mifareClassic4K
        case mifareClassicMini
        case mifareDesfire
        case jcopCard
        case infineonCard
        case unknown(sak: UInt8)

        var description: String {
            switch self {
            case .mifareUltralight: return "MIFARE Ultralight"
            case .mifareClassic1K: return "MIFARE Classic 1K"
            case .mifareClassic4K: return "MIFARE Classic 4K"
            case .mifareClassicMini: return "MIFARE Classic Mini"
            case .mifareDesfire: return "MIFARE DESFire"
            case .jcopCard: return "JCOP Card"
            case .infineonCard: return "Infineon Card"
            case .unknown(let sak): return "Unknown (SAK: 0x\(String(sak, radix: 16, uppercase: true)))"
            }
        }
    }
}

// MARK: - String Formatting

extension ISO14443AInfo: CustomStringConvertible {
    var description: String {
        return """
        ISO14443A Info:
          ATQA: \(atqaHex)
          SAK: \(sakHex)
          UID: \(uidHex) (\(uidType.description))
          Card Type: \(cardType.description)
          ATS: \(atsHex)\(hasATS ? "" : " (none)")
        """
    }

    var atqaHex: String {
        return String(format: "%02X %02X", atqa.0, atqa.1)
    }

    var sakHex: String {
        return String(format: "0x%02X", sak)
    }

    var uidHex: String {
        return uid.map { String(format: "%02X", $0) }.joined(separator: " ")
    }

    var atsHex: String {
        guard !ats.isEmpty else { return "" }
        return ats.map { String(format: "%02X", $0) }.joined(separator: " ")
    }
}

// MARK: - Convenience Initializers

extension ISO14443AInfo {
    /// Create from hex string (for testing/debugging)
    static func fromUIDHex(_ hexString: String) -> ISO14443AInfo? {
        let hex = hexString.replacingOccurrences(of: " ", with: "")
        guard hex.count % 2 == 0 else { return nil }

        var data = Data()
        var index = hex.startIndex
        while index < hex.endIndex {
            let nextIndex = hex.index(index, offsetBy: 2)
            if let byte = UInt8(hex[index..<nextIndex], radix: 16) {
                data.append(byte)
            } else {
                return nil
            }
            index = nextIndex
        }

        return ISO14443AInfo(
            atqa: (0x00, 0x00),
            sak: 0x00,
            uid: data
        )
    }
}

// MARK: - Equatable & Hashable

extension ISO14443AInfo: Equatable {
    static func == (lhs: ISO14443AInfo, rhs: ISO14443AInfo) -> Bool {
        return lhs.atqa == rhs.atqa &&
               lhs.sak == rhs.sak &&
               lhs.uid == rhs.uid &&
               lhs.ats == rhs.ats
    }
}

extension ISO14443AInfo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(atqa.0)
        hasher.combine(atqa.1)
        hasher.combine(sak)
        hasher.combine(uid)
        hasher.combine(ats)
    }
}
