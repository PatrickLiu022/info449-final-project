//
//  RecipeViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class RecipeViewController: UIViewController {
    
    // TODO: Modify after fetching
    //var currRecipe : Recipe = nil
    var currRecipeName : String = ""

    var doneButtonDestination = ""   // homeVC or favVC
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeToContentVC" {
            if let contentVC = segue.destination as? ContentViewController {
                
                // TODO: modify after fetching
                //contentVC.currRecipe = currRecipe
                contentVC.currRecipeName = currRecipeName
                
                contentVC.doneButtonDestination = doneButtonDestination
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // TODO: Modify after fetching
        //recipeNameLabel.text = currRecipe.recipeName
        recipeNameLabel.text = currRecipeName
        // TODO: Uncomment after fetching
        //ingredientsLabel.text = currRecipe.ingredients
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
