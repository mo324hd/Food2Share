//
//  Extension.swift
//  Food2Share_Main
//
//  Created by BP-36-224-17 on 02/01/2026.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }
}
