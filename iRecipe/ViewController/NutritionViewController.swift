//
//  NutritionViewController.swift
//  iRecipe
//
//  Created by Helen Li on 6/7/22.
//

import UIKit

// Display HTML text
extension String {
    var htmlToAttributedString : NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

class NutritionViewController: UIViewController {
    
    var indexPathRow : Int = -1
    var doneButtonDestination : String = ""
    
    @IBOutlet weak var nutritionLabel: UILabel!
    
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
        let nutritionText = RecipeData.instance.nutritionHtmlTexts[indexPathRow]
        nutritionLabel.text = nutritionText
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
