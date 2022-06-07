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

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if doneButtonDestination == "viewController" { // go back to "home"
            if let mainVC = storyboard?.instantiateViewController(withIdentifier: "viewController") as? ViewController {
                self.navigationController?.pushViewController(mainVC, animated: true)
            }
        } else { // go back to "fav"
            if let favVC = storyboard?.instantiateViewController(withIdentifier: "favViewController") as? FavViewController {
                self.navigationController?.pushViewController(favVC, animated: true)
            }
        }
    }

    @IBAction func favButtonPressed(_ sender: UIButton) {
        if FavRecipe.instance.favRecipes.contains(where: { $0.title == currRecipe!.title }) { // unfav curr recipe
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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ingredientsLabel.text = "\(RecipeData.instance.ingredientLists[currRecipe!.id]!)"
        self.instructionLabel.text = RecipeData.instance.fullSteps[currRecipe!.id]
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
