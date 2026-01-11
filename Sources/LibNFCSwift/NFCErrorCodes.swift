//
//  LibNFCErrorCodes.swift
//  LibNFCSwift
//
//  Created by Diggory Laycock on 11/01/2026.
//


/// NFC error codes
public enum NFCError: Int, Error, CustomStringConvertible {
    case success = 0
    case io = -1
    case invalidArgument = -2
    case deviceNotSupported = -3
    case noSuchDevice = -4
    case overflow = -5
    case timeout = -6
    case operationAborted = -7
    case notImplemented = -8
    case targetReleased = -10
    case rfTransmission = -20
    case mifareAuthFailed = -30
    case software = -80
    case chip = -90

    public var description: String {
        switch self {
        case .success: return "Success (no error)"
        case .io: return "I/O error, device may not be usable"
        case .invalidArgument: return "Invalid argument(s)"
        case .deviceNotSupported: return "Operation not supported by device"
        case .noSuchDevice: return "No such device"
        case .overflow: return "Buffer overflow"
        case .timeout: return "Operation timed out"
        case .operationAborted: return "Operation aborted (by user)"
        case .notImplemented: return "Not (yet) implemented"
        case .targetReleased: return "Target released"
        case .rfTransmission: return "Error while RF transmission"
        case .mifareAuthFailed: return "MIFARE Classic: authentication failed"
        case .software: return "Software error (allocation, file/pipe creation, etc.)"
        case .chip: return "Device's internal chip error"
        }
    }
}
