//
//  ContentViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class ContentViewController: UIViewController {

    var currRecipe : Recipe? = nil
    var doneButtonDestination : String = ""
    
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!

    @IBAction func favButtonPressed(_ sender: UIButton) {
        if FavRecipe.instance.favRecipes.contains(where: { $0.name == currRecipe!.name }) { // unfav curr recipe
            FavRecipe.instance.unfavCurrRecipe(currRecipe!)
            favButton.setTitle("Save to Fav", for: .normal)

            let alert = UIAlertController(title: "Success", message: "Unsaved from Fav!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else { // fav curr recipe
            FavRecipe.instance.favCurrRecipe(currRecipe!)
            favButton.setTitle("Unsave from Fav", for: .normal)

            let alert = UIAlertController(title: "Success", message: "Saved to Fav!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contentToNutritionVC" {
            if let nutritionVC = segue.destination as? NutritionViewController {
                nutritionVC.currRecipe = self.currRecipe
                nutritionVC.doneButtonDestination = self.doneButtonDestination
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ingredientsLabel.text = "\(currRecipe!.ingredientList)"
        self.instructionLabel.text = currRecipe!.instruction
        
        let favButtonTitle = FavRecipe.instance.setFavButtonTitle(currRecipe!)
        favButton.setTitle(favButtonTitle, for: .normal)
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
