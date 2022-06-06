//
//  Recipe.swift
//  iRecipe
//
//  Created by Helen Li on 6/1/22.
//

import Foundation

struct Recipe : Decodable {
    let recipeName : String
    let recipeDesc : String
    let ingredients : String
    let instructions : String
}
