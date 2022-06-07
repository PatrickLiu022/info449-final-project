//
//  ViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit
import Network
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /* Variables */

    // Network
    let monitor = NWPathMonitor()
    var networkAvail : Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    
    /* Table View Methods */
    
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
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),
                           forCellReuseIdentifier: "tableViewCell")
    }
    
    /* View */
    
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
        RecipeData.instance.dataSetUp()
        self.setUpTableView()
        
        
        
//        // check network
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied { // connected to network
//                self.networkAvail = true
//
//                // set up fetched data
//                RecipeData.instance.dataSetUp()
//
//                // set up the table view with fetched data
//                self.setUpTableView()
//                self.tableView.reloadData()
//            } else { // network not available
//                self.networkAvail = false
//
//                // TODO: handle local
//                // load local data
//                if let localData = self.readLocalData(forName: "data") {
//                    self.genInfo = try! JSONDecoder().decode([Recipe].self, from: localData)
//                }
//                self.setUpTableView()
//            }
//        }
//
//        // set up dispatch queue for delegate
//        let queue = DispatchQueue(label: "Monitor")
//        monitor.start(queue: queue)
//        monitor.cancel()
        
        
//        if networkAvail {
//            fireAlert(alertTitle: "Welcome", alertMessage: "Ready to go!")
//        } else {
//            fireAlert(alertTitle: "Network not available", alertMessage: "Load local data")
//        }
    }
}
