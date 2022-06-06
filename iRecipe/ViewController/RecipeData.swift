//
//  RecipeData.swift
//  iRecipe
//
//  Created by Helen Li on 6/6/22.
//

import Foundation
import UIKit

class RecipeData {

    static let instance = RecipeData()
    
    var recipeIds : [Int]
    var recipeTastes : [String]
    var recipeImageUrls : [String]
    var recipeImages : [UIImage]


    init() {
        self.recipeIds = []
        self.recipeTastes = []
        self.recipeImageUrls = []
        self.recipeImages = []
    }

}
