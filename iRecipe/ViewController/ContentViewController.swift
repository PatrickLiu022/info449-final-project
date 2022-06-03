//
//  ContentViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class ContentViewController: UIViewController {
    
    // TODO: Modify after fetching
    //var currRecipe : Recipe = nil
    var currRecipeName : String = ""
    
    var doneButtonDestination : String = ""

    // TODO: Modify after fetching
    var instructions : String = ""
    // TODO: IBOutlet connections for "instructionsLabel"
    // Do NOT connect the label now; make sure how the data looks like first!!
    
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
        // TODO: Modify after fetching
        //if FavRecipes.instance.favRecipes.contains(currRecipe) {} else {}
        if FavRecipes.instance.favRecipeNames.contains(currRecipeName) { // unfav curr recipe
            FavRecipes.instance.unfavCurrRecipe(currRecipeName)
            favButton.setTitle("Save to Fav", for: .normal)
            
            let alert = UIAlertController(title: "Success", message: "Unsaved from Fav!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else { // fav curr recipe
            FavRecipes.instance.favCurrRecipe(currRecipeName)
            favButton.setTitle("Unsave from Fav", for: .normal)
            
            let alert = UIAlertController(title: "Success", message: "Saved to Fav!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // TODO: Modify after fetching
        //let favButtonTitle = FavRecipes.instance.setFavButtonTitle(currRecipe)
        let favButtonTitle = FavRecipes.instance.setFavButtonTitle(currRecipeName)
        
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
