//
//  Recipe.swift
//  iRecipe
//
//  Created by Helen Li on 6/7/22.
//

import Foundation
import UIKit

// for fetching
class Recipe {
    var id : Int             // recipe id
    var name : String        // recipe name
    var imageUrl : String    // recipe image's url
    var calories : Int       // recipe calories value
    
    var tastes : String      // recipe's tastes
    var image : UIImage?      // recipe image
    var ingredientList : [String] // recipe ingredients
    var instruction : String // recipe instruction containing all steps
    var nutritionAttrText : NSAttributedString? // recipe's nutrition facts
    
    init(recipeId: Int, recipeName: String, recipeImageUrl: String, recipeCalories: Int) {
        self.id = recipeId
        self.name = recipeName
        self.imageUrl = recipeImageUrl
        self.calories = recipeCalories
        
        self.tastes = ""
        self.image = nil
        self.ingredientList = []
        self.instruction = ""
        self.nutritionAttrText = nil
    }
    
    func addTastes(_ tastesText: String) {
        self.tastes = tastesText
    }
    
    func addImage(_ recipeImage: UIImage) {
        self.image = recipeImage
    }
    
    func addIngredients(_ ingredient: String) {
        self.ingredientList.append(ingredient)
    }
    
    func addInstruction(_ instruction: String) {
        self.instruction = instruction
    }
    
    func addNutrAttrText(_ nutrAttrText: NSAttributedString) {
        self.nutritionAttrText = nutrAttrText
    }
}
