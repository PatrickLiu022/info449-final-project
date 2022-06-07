//
//  FilterViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class FilterTableDataSource: NSObject, UITableViewDataSource {
    
    var results : [Recipe] = []

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        cell.recipeNameLabel.text = results[indexPath.row].title
        cell.recipeCaloriesLabel.text = "Calories: \(results[indexPath.row].calories)"
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
}

// Checks whether the value of a string is an integer
extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

class FilterViewController: UIViewController, UITableViewDelegate {
    
    var MAX_CALORIES : Int = -1
    let MIN_CALORIES : Int = 0
    
    var allRecipes : [Recipe] = []
    var filterResults : [Recipe] = []
    
    var filterTableDataSource = FilterTableDataSource()
    
    @IBOutlet weak var minCaloriesTextField: UITextField!
    @IBOutlet weak var maxCaloriesTextField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var filterTableView: UITableView!
    
    func filterRecipes(minCalories : Int, maxCalories : Int) {
        for recipe in allRecipes { //&& !searchResults.contains(recipe)
            if recipe.calories >= minCalories && recipe.calories <= maxCalories { // exists recipes satisfing constraints
                filterResults.append(recipe)
            }
        }
    }
    
    func fireAlert(alertTitle : String, alertMessage : String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: {
            NSLog("\(alertTitle) fired")
        })
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        let minCaloriesInput = minCaloriesTextField.text
        let maxCaloriesInput = maxCaloriesTextField.text
        if minCaloriesInput != "" && maxCaloriesInput != "" { // both text fields have input
            if minCaloriesInput!.isInt && maxCaloriesInput!.isInt {
                if Int(minCaloriesInput!)! > Int(maxCaloriesInput!)! {
                    fireAlert(alertTitle: "Invalid Bounds", alertMessage: "Please make sure min <= max")
                } else {
                    filterRecipes(minCalories: Int(minCaloriesInput!)!, maxCalories: Int(maxCaloriesInput!)!)
                }
            } else { // non-valid input(s)
                fireAlert(alertTitle: "Invalid Inputs", alertMessage: "Please give integer inputs")
            }
        } else if minCaloriesInput != "" { // only minCalories given
            if minCaloriesInput!.isInt {
                filterRecipes(minCalories: Int(minCaloriesInput!)!, maxCalories: self.MAX_CALORIES)
            } else {
                fireAlert(alertTitle: "Error", alertMessage: "Please give integer input")
            }
        } else if maxCaloriesInput != "" { // only maxCalories given
            if maxCaloriesInput!.isInt {
                filterRecipes(minCalories: self.MIN_CALORIES, maxCalories: Int(maxCaloriesInput!)!)
            } else {
                fireAlert(alertTitle: "Error", alertMessage: "Please give integer input")
            }
        } else { // both text fields are empty
            self.fireAlert(alertTitle: "Sorry", alertMessage: "Please type in values to filter recipes")
        }
        
        if filterResults.count == 0 { // no results found
            noResultLabel.isHidden = false
        } else { // display results
            filterTableDataSource.results = filterResults
            filterTableView.dataSource = filterTableDataSource
            filterTableView.reloadData()

            noResultLabel.isHidden = true
        }

        dismissButton.isHidden = false
        checkButton.isEnabled = false
        minCaloriesTextField.isEnabled = false
        maxCaloriesTextField.isEnabled = false
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        // clean filter results
        filterResults = []
        
        // clean filter table view
        filterTableDataSource.results = []
        filterTableView.reloadData()

        dismissButton.isHidden = true
        noResultLabel.isHidden = true
        minCaloriesTextField.isEnabled = true
        maxCaloriesTextField.isEnabled = true
        checkButton.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // connects to RecipeViewController
        if let recipeVC = storyboard?.instantiateViewController(withIdentifier: "recipeViewController") as? RecipeViewController {
            recipeVC.currRecipe = filterResults[indexPath.row]
            recipeVC.indexPathRow = indexPath.row
            self.navigationController?.pushViewController(recipeVC, animated: true)
        }

        // updates history record
        let viewedRecipeName = filterResults[indexPath.row].title
        ViewHistory.instance.updatesHistory(viewedRecipeName)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        filterTableView.delegate = self
        filterTableView.register(UINib(nibName: "TableViewCell", bundle: nil),
                           forCellReuseIdentifier: "tableViewCell")
        minCaloriesTextField.text = ""
        minCaloriesTextField.placeholder = "Type in an integer value here"
        maxCaloriesTextField.text = ""
        maxCaloriesTextField.placeholder = "Type in an integer value here"
        dismissButton.isHidden = true
        noResultLabel.isHidden = true
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
