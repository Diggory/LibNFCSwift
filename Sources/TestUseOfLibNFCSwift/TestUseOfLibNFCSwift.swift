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
        print("Hello")
        print("libnfc v. \(NFC().libNFCVersion() ?? "No version available")")
    }
}
