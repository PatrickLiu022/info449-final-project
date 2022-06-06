//
//  Instructions.swift
//  iRecipe
//
//  Created by Helen Li on 6/5/22.
//

import Foundation

// Information of an ingredient
struct Ingredient : Decodable {
    let id : Int
    let name : String
    let localizedName : String
    let image : String
}

// Information of an equipment
struct Equipment : Decodable {
    let id : Int
    let name : String
    let localizedName : String
    let image : String
}

// A step of the instruction
struct Step : Decodable {
    let number : Int // the number of steps
    let step : String // description of what to do in this step
    let ingredients : [Ingredient]
    let equipment : [Equipment]
}

// Instruction of a recipe
struct Instruction : Decodable {
    let name : String
    let steps : [Step]
}
