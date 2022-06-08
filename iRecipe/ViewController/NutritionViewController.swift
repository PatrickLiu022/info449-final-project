//
//  NutritionViewController.swift
//  iRecipe
//
//  Created by Helen Li on 6/7/22.
//

import UIKit

class NutritionViewController: UIViewController {
    
    var indexPathRow : Int = -1
    
    @IBOutlet weak var nutritionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nutritionAttrText = RecipeData.instance.nutritionAttrTexts[indexPathRow]
        nutritionTextView.attributedText = nutritionAttrText
        nutritionTextView.isEditable = false 
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
