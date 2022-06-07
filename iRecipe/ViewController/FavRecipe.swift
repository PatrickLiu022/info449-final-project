//
//  FavRecipes.swift
//  iRecipe
//
//  Created by Helen Li on 6/2/22.
//

import Foundation

class FavRecipe {

    static let instance = FavRecipe()

    var favRecipes : [Recipe]

    init() {
        self.favRecipes = []
    }

    func favCurrRecipe(_ currRecipe : Recipe) {
        favRecipes.insert(currRecipe, at: 0)
    }

    func unfavCurrRecipe(_ currRecipe : Recipe) {
        favRecipes.removeAll { recipe in
            return recipe.name == currRecipe.name
        }
    }

    func setFavButtonTitle(_ currRecipe : Recipe) -> String {
        if favRecipes.contains(where: { $0.name == currRecipe.name }) {
            return "Unsave from Fav"
        } else {
            return "Save to Fav"
        }
    }

}
