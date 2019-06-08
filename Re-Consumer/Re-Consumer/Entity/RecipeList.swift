//
//  RecipeList.swift
//  Re-Consumer
//
//  Created by iniad on 2019/06/08.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

struct RecipeList: Codable {
    let material: String
    let materialID: String
    let recipes: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case material
        case materialID = "material_id"
        case recipes
    }
}


