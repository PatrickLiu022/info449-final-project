//
//  Recipe.swift
//  iRecipe
//
//  Created by Helen Li on 6/1/22.
//

import Foundation

// General information of a recipe; look for more information of each recipe by "id"
struct RecipeGenInfo : Decodable {
    let id : Int           // recipe id
    let title : String     // recipe name
    let image : String     // image url
    let imageType : String // "jpg"
    let calories : Int     // number of calories
    let protein : String   // "<num>g"
    let fat : String       // "<num>g"
    let carbs : String     // "<num>g"
}
