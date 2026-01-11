//
//  NFCTypes.swift
//  LibNFCSwift
//
//  Created by Diggory Laycock on 11/01/2026.
//

//import Foundation
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
