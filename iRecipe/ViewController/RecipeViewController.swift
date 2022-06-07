//
//  RecipeViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class RecipeViewController: UIViewController {

    var currRecipe : Recipe? = nil
    var indexPathRow : Int = -1
    var doneButtonDestination = "" // homeVC or favVC

    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var tastesLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeToContentVC" {
            if let contentVC = segue.destination as? ContentViewController {
                contentVC.currRecipe = currRecipe
                contentVC.doneButtonDestination = doneButtonDestination
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.recipeNameLabel.text = currRecipe!.title
        self.tastesLabel.text = RecipeData.instance.recipeTastes[indexPathRow]
        self.recipeImageView.image = RecipeData.instance.recipeImages[indexPathRow]
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
