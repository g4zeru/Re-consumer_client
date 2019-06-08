//
//  CodableError.swift
//  NetworkLayer
//
//  Created by iniad on 2019/05/21.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

public enum CodableError: Error {
    case encode(Codable.Type?)
    case decode(Codable.Type?)
}
