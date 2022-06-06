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
    
    var recipes : [Recipe] = []
    var recipeIds : [Int] = []

    // look for 6 recipes satisfying 10 <= carb <= 50
    let recipeUrl = "https://api.spoonacular.com/recipes/findByNutrients?minCarbs=10&maxCarbs=50&number=6&apiKey=f130ece44f9f4817a32b8aaa54c596d1"

//    // Network
//    let monitor = NWPathMonitor()
//    var networkAvail = false
    
    @IBOutlet weak var tableView: UITableView!
    
    
    /* Table View Methods */
    
    // Defines each table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        cell.recipeNameLabel.text = recipes[indexPath.row].title
        cell.recipeCaloriesLabel.text = "Calories: \(recipes[indexPath.row].calories)"
        return cell
    }
    
    // Defines the number of table cells being displayed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    // Defines the height of each table cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    // Defines action of each table cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // connects to RecipeViewController
        if let recipeVC = storyboard?.instantiateViewController(withIdentifier: "recipeViewController") as? RecipeViewController {
            recipeVC.currRecipe = recipes[indexPath.row]
            recipeVC.currRecipeId = recipeIds[indexPath.row]
            recipeVC.doneButtonDestination = "viewController"
            self.navigationController?.pushViewController(recipeVC, animated: true)
        }

        // updates history record
        let viewedRecipeName = recipes[indexPath.row].title
        ViewHistory.instance.updatesHistory(viewedRecipeName)
    }
    
    // Set up "home" table view
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),
                           forCellReuseIdentifier: "tableViewCell")
    }
    
    
//    /* Method to Pass Data to Other VCs */
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "homeToSearchVC" {
//            if let searchVC = segue.destination as? SearchViewController {
//                searchVC.allRecipes = genInfo
//            }
//        }
//    }
    
    
    /* Data Fetching Methods */
    
//    // Read the local json file
//    private func readLocalData(forName name: String) -> Data? {
//        do {
//            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
//                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
//                return jsonData
//            }
//        } catch {
//            print(error)
//        }
//        return nil
//    }
    
    func fireAlert(alertTitle : String, alertMessage : String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: {
            NSLog("\(alertTitle) fired")
        })
    }
    
    private func fetchData(_ fetchingUrlStr : String) {
        let request = URLRequest(url: URL(string: fetchingUrlStr)!)
        
        URLSession.shared.dataTask(with: request) { [weak self]  data, response, error in
            
            guard let self = self else { return }
            
            guard error == nil else {
                print("Cannot parse data")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else {
                print("Error with http response")
                return
            }
            
            guard let data = data else {
                print("No data found")
                return
            }
            
            if let recipeData = try? JSONDecoder().decode([Recipe].self, from: data) {
                DispatchQueue.main.async {
                    self.recipes = recipeData
                    
                    for recipe in self.recipes {
                        self.recipeIds.append(recipe.id)
                    }
                    
                    self.setUpTableView()
                    self.tableView.reloadData()
                }
            } else {
                print("Failed to fetch data")
                return
            }
        }.resume()
    }
    
    
    /* View */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.fetchData(self.recipeUrl)
        
//        // check network
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied { // connected to network
//                self.networkAvail = true
//
//                // fetch data
//                self.fetchData(self.urlStrGenInfo)
//            }
            
//            // TODO: handle local
//            else { // network not available
//                self.networkAvail = false
//
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
        
//        // send alert if network not available
//        if !networkAvail {
//            fireAlert(alertTitle: "Network not available", alertMessage: "Loaded local data")
//        }
    }
}
