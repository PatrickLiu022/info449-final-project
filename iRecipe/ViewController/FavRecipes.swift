//
//  FavRecipes.swift
//  iRecipe
//
//  Created by Helen Li on 6/2/22.
//

import Foundation

class FavRecipes {
    
    static let instance = FavRecipes()
    
    // TODO: Modify after fetching
    //var favRecipes : [Recipe]
    var favRecipeNames : [String]
    
    init() {
        // TODO: Modify after fetching
        //self.favRecipes = []
        self.favRecipeNames = []
    }
    
    // TODO: Modify after fetching
//    func favCurrRecipe(_ currRecipe : Recipe) {
//    }
//    func unfavCurrRecipe(_ currRecipe : Recipe) {
//    }
//    func setFavButtonTitle(_ recipe : Recipe) {
//
//    }
    func favCurrRecipe(_ currRecipeName : String) {
        print("About to fav \(currRecipeName)")
        favRecipeNames.append(currRecipeName)
        print("Done: \(favRecipeNames)")
    }
    func unfavCurrRecipe(_ currRecipeName : String) {
        print("About to un-fav \(currRecipeName)")
        favRecipeNames = favRecipeNames.filter() { $0 != currRecipeName }
        print("Done: \(favRecipeNames)")
    }
    func setFavButtonTitle(_ currRecipeName : String) -> String {
        if favRecipeNames.contains(currRecipeName) {
            return "Unsave from Fav"
        } else {
            return "Save to Fav"
        }
    }
    
}