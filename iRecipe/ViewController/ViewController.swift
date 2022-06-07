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
    var isLoading = false
    
    // for fetching spoonacular API
    let API_KEY = "f130ece44f9f4817a32b8aaa54c596d1" // wlimath
    // f130ece44f9f4817a32b8aaa54c596d1 <-- use this one if limit is reached
    // ed5f10cc83e4459aa76705e7ea396117

    // Network
    let monitor = NWPathMonitor()
    var networkAvail : Bool = false
    
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
            recipeVC.doneButtonDestination = "viewController"
            recipeVC.API_KEY = self.API_KEY
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
    
    
    /* Method to Pass Data to Other VCs */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToSearchVC" {
            if let searchVC = segue.destination as? SearchViewController {
                searchVC.allRecipes = recipes
            }
        }
        
        if segue.identifier == "homeToFilterVC" {
            if let filterVC = segue.destination as? FilterViewController {
                filterVC.allRecipes = recipes
                filterVC.MAX_CALORIES = 2000
            }
        }
    }
    
    
    /* Data Fetching Methods */
    
    func fireAlert(alertTitle : String, alertMessage : String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: {
            NSLog("\(alertTitle) fired")
        })
    }
    
    private func fetchData(_ fetchingUrlStr : String) {
        let request = URLRequest(url: URL(string: fetchingUrlStr)!)
        self.isLoading = false
        
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
                    self.recipes.remove(at: 3)
                    self.setUpTableView()
                    self.tableView.reloadData()
                }
            } else {
                print("Failed to fetch data")
                return
            }
        }.resume()
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading {
            fetchMoreData()
        }
    }
    
    private func fetchMoreData() {
        if !self.isLoading {
            self.isLoading = true
            let start = recipes.count
            let end = start + 6
            DispatchQueue.global().async {
                sleep(2)
                for i in start...end {
                    self.fetchDataWithoutReloadingEntireTable()
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
    private func fetchDataWithoutReloadingEntireTable() {
        let request = URLRequest(url: URL(string: "https://api.spoonacular.com/recipes/random?apiKey=\(self.API_KEY)")!)
        
        self.isLoading = false
        URLSession.shared.dataTask(with: request) {
            [weak self] data, response, error in
            
            guard let self = self else {return}
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else {
                print("Error with http response without reloading entire table")
                return
            }
            
            guard let data = data else {
                print("No data found")
                return
            }
            
            if let recipeData = try?
                JSONDecoder().decode([Recipe].self, from: data) {
                DispatchQueue.main.async {
                    self.recipes = recipeData
                    self.recipes.remove(at: 3)
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
        
        // look for recipes with 10 <= carb <= 50
        let recipeUrl = "https://api.spoonacular.com/recipes/findByNutrients?minCarbs=10&maxCarbs=50&number=7&apiKey=\(self.API_KEY)"
    
        // check network
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied { // connected to network
                self.networkAvail = true
                
                // fetch data
                self.fetchData(recipeUrl)
            } else { // network not available
                self.networkAvail = false
                
//                // TODO: handle local
//                // load local data
//                if let localData = self.readLocalData(forName: "data") {
//                    self.genInfo = try! JSONDecoder().decode([Recipe].self, from: localData)
//                }
//                self.setUpTableView()
            }
        }

        // set up dispatch queue for delegate
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.cancel()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        if !networkAvail {
//            self.fireAlert(alertTitle: "Network not available", alertMessage: "Please connect to a network")
//        }
//    }
}
