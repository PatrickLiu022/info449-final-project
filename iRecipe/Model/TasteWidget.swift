//
//  Taste.swift
//  iRecipe
//
//  Created by Helen Li on 6/5/22.
//

import Foundation

// Taste widget of a recipe
struct TasteWidget : Decodable {
    let sweetness : Float
    let saltiness : Float
    let sourness : Float
    let bitterness : Float
    let savoriness : Float
    let fattiness : Float
    let spiciness : Float
}
