//
//  RecipeViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class RecipeViewController: UIViewController {
    
    //var recipes : [Recipe] = []
    var recipeNames : [String] = []  // TODO: DELETE, uncommet above line
    var indexPathRow = -1 // value will be assigned from "Home" ViewController
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    
//    // TODO: UNCOMMENT THIS FUNC
//    // Find which recipe the user pressed on from "Home"
//    func currRecipe() -> Recipe {
//        recipes[indexPathRow]
//    }
    
    // Defines action after pressing the "view" button
    @IBAction func viewButtonPressed(_ sender: UIButton) {
        // auto change to ContentViewController (done)
        
//        // connects to ContentViewController
//        if let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController {
//            // TODO: add actions
//        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //recipeNameLabel.text = currRecipe().recipeName
        recipeNameLabel.text = recipeNames[indexPathRow] // TODO: DELETE, uncomment above
        
        //ingredientsLabel.text = currRecipe().ingredients // TODO: UNCOMMENT THIS LINE
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
