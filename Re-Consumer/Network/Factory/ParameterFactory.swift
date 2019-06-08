//
//  ParameterFactory.swift
//  NetworkLayer
//
//  Created by iniad on 2019/05/22.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

protocol ParameterFactory {
    func generate(prameter: [String: String]) throws -> Data
}

class ParameterFactoryImpl: ParameterFactory {
    func generate(prameter: [String : String]) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: prameter, options: JSONSerialization.WritingOptions.sortedKeys)
        } catch {
            throw CodableError.encode(nil)
        }
    }
}
