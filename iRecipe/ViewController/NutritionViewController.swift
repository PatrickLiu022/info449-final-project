//
//  NutritionViewController.swift
//  iRecipe
//
//  Created by Helen Li on 6/7/22.
//

import UIKit

class NutritionViewController: UIViewController {
    
    var currRecipe : Recipe? = nil 
    var doneButtonDestination : String = ""
    
    @IBOutlet weak var nutritionTextView: UITextView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nutritionAttrText = currRecipe!.nutritionAttrText
        nutritionTextView.attributedText = nutritionAttrText
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
