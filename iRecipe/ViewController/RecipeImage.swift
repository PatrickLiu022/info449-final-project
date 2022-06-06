//
//  RecipeImages.swift
//  iRecipe
//
//  Created by Helen Li on 6/5/22.
//

import UIKit
import Foundation

class RecipeImage {

    static let instance = RecipeImage()

    var imageData : [UIImage]

    init() {
        self.imageData = []
    }

    func appendImage(_ currImage : UIImage) {
        imageData.append(currImage)
    }

}
