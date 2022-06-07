//
//  ViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Defines each table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        cell.recipeNameLabel.text = RecipeData.instance.recipes[indexPath.row].name
        cell.recipeCaloriesLabel.text = "Calories: \(RecipeData.instance.recipes[indexPath.row].calories)"
        return cell
    }
    
    // Defines the number of table cells being displayed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeData.instance.recipes.count
    }
    
    // Defines the height of each table cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    // Defines action of each table cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // connects to RecipeViewController
        if let recipeVC = storyboard?.instantiateViewController(withIdentifier: "recipeViewController") as? RecipeViewController {
            recipeVC.currRecipe = RecipeData.instance.recipes[indexPath.row]
            recipeVC.doneButtonDestination = "viewController"
            self.navigationController?.pushViewController(recipeVC, animated: true)
        }

        // updates history record
        let viewedRecipeName = RecipeData.instance.recipes[indexPath.row].name
        ViewHistory.instance.updatesHistory(viewedRecipeName)
    }
    
    // Set up "home" table view
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),
                           forCellReuseIdentifier: "tableViewCell")
    }
    
//    func fireAlert(alertTitle : String, alertMessage : String) {
//        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: {
//            NSLog("\(alertTitle) fired")
//        })
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // set up data
        RecipeData.instance.vc = self
        RecipeData.instance.dataSetUp()
        
//        if RecipeData.instance.networkAvail {
//            fireAlert(alertTitle: "Welcome", alertMessage: "Ready to go!")
//        } else {
//            fireAlert(alertTitle: "Network not available", alertMessage: "Load local data")
//        }
    }
}
