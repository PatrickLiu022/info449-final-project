//
//  Recipe.swift
//  iRecipe
//
//  Created by Helen Li on 6/1/22.
//

import Foundation

struct Recipe : Decodable {
    let recipeName : String        // recipe name
    let recipeDesc : String   // recipe intro or description
    let ingredients : [String] // list of ingredients
    
    // TODO: Other info about each recipe
}
