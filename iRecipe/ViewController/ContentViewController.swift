//
//  ContentViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class ContentViewController: UIViewController {
    
    //var currRecipe : Recipe = nil
    var currRecipeName : String = "" // TODO: DELETE, uncomment above
    
    
    var favButtonTitle : String = "" // text displayed on the fav button
    var favRecipeNames : [String] = []
    
    // TODO: Modify current assumption
    var instructions : String = ""
    
    // IBOutlet connections for "instructionsLabel"
    // Do NOT connect the label now
    // Make sure how the data looks like first!!
    
    
    
    
    @IBOutlet weak var favButton: UIButton!
    
    // Defines action after pressing "done"
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        // go back to "home"
        if let mainVC = storyboard?.instantiateViewController(withIdentifier: "viewController") as? ViewController {
            self.navigationController?.pushViewController(mainVC, animated: true)
        }
    }
    
    @IBAction func favButtonPressed(_ sender: UIButton) {
        //if favRecipes.contains(currRecipe) && favRecipes.count > 0 {} else {}
        if favRecipeNames.contains(currRecipeName) && favRecipeNames.count > 0 { // unsave from favorites
            print(favRecipeNames)
            print("About to UNSAVE chosen recipe from fav")
            
            favRecipeNames = favRecipeNames.filter() { $0 !=  currRecipeName}
            favButton.setTitle("Save to Fav", for: .normal)
            let alert = UIAlertController(title: "Success", message: "Unsaved from Fav!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            print("Unsaved!")
            print(favRecipeNames)
        } else { // save to favorites
            print(favRecipeNames)
            print("About to SAVE chosen recipe from fav")
            
            favRecipeNames.append(currRecipeName)
            favButton.setTitle("Unsave from Fav", for: .normal)
            let alert = UIAlertController(title: "Success", message: "Saved to Fav!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            print("Saved!")
            print(favRecipeNames)
        } // TODO: DELETE, uncomment above
    }
    
    // TODO: pass "favRecipeNames" to FavViewController's favRecipeNames
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set button text for the fav button
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
