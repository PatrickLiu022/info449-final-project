//
//  Recipe.swift
//  iRecipe
//
//  Created by Helen Li on 6/1/22.
//

import Foundation

//struct Recipe : Decodable {
//    let recipeName : String
//    let recipeDesc : String
//    let ingredients : String
//    let instructions : String
//}

// General information of a recipe; look for more information of each recipe by "id"
struct Recipe : Decodable {
    let id : Int           // recipe id
    let title : String     // recipe title
    let image : String     // image url
    let imageType : String // "jpg"
    let calories : Int     // number of calories
    let protein : String   // "<num>g"
    let fat : String       // "<num>g"
    let carbs : String     // "<num>g"
}
