//
//  ViewHistory.swift
//  iRecipe
//
//  Created by Helen Li on 6/2/22.
//

import Foundation

class ViewHistory {

    static let instance = ViewHistory()

    var viewedRecipeNames : [String]

    init() {
        self.viewedRecipeNames = []
    }

    func updatesHistory(_ currRecipeName : String) {
        if viewedRecipeNames.contains(currRecipeName) {
            // remove "currRecipeName" from record
            viewedRecipeNames = viewedRecipeNames.filter() { $0 != currRecipeName }
        }
        // add "currRecipeName" to the front of the array
        viewedRecipeNames.insert(currRecipeName, at: 0)
    }

}
