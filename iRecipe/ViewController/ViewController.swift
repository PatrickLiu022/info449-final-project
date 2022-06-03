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
    
    // Data
    var recipes : [Recipe] = []
//    let recipeNames = ["recipe1 for testing", "recipe2 for testing", "recipe3 for testing", "recipe4 for testing", "recipe5 for testing", "recipe16 for testing"]
//    let recipeDescs = ["desc for testing recipe1", "desc for testing recipe2", "desc for testing recipe3", "desc for testing recipe4", "desc for testing recipe5", "desc for testing recipe6"]
    let urlStr = "https://api.spoonacular.com/recipes/random?apiKey=f130ece44f9f4817a32b8aaa54c596d1"
    
    // Network
    let monitor = NWPathMonitor()
    var networkAvail = "false" // a boolean reflecting whether network is available
    
    // UI Connections
    @IBOutlet weak var tableView: UITableView!
    
    
    /* Table View Methods */
    
    // Defines each table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        cell.recipeNameLabel.text = recipes[indexPath.row].recipeName
        cell.recipeDescLabel.text = recipes[indexPath.row].recipeDesc
//        cell.recipeNameLabel.text = recipeNames[indexPath.row]
//        cell.recipeDescLabel.text = recipeDescs[indexPath.row]
        return cell
    }
    
    // Defines the number of table cells being displayed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
//        return recipeNames.count
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
//            recipeVC.currRecipeName = recipeNames[indexPath.row]
            recipeVC.doneButtonDestination = "viewController"
            self.navigationController?.pushViewController(recipeVC, animated: true)
        }
        
        // updates history record
        let viewedRecipeName = recipes[indexPath.row].recipeName
//        let viewedRecipeName = recipeNames[indexPath.row]
        ViewHistory.instance.updatesHistory(viewedRecipeName)
    }
    
    
    /* Method to Pass Data to Other VCs */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToSearchVC" {
            if let searchVC = segue.destination as? SearchViewController {
                searchVC.allRecipes = recipes
//                searchVC.allRecipeNames = recipeNames
            }
        }
    }
    
    
    /* Data Fetching Methods */
    
    func alertController(alertType : String, alertMessage : String) {
        let alert = UIAlertController(title: alertType, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: {
            NSLog("\(alertType) fired")
        })
    }
    
    func setUpMonitor(_ sender: Any) {
        // check network
        monitor.pathUpdateHandler = { [self] path in
            if path.status == .satisfied { // Connected to network
                print("Connected to network")
                self.fetchData(self.urlStr)
            } else { // Network not available
                print("Network not available")
                self.alertController(alertType: "Notification", alertMessage: "Network is not available")
            }
        }
        
        // set up dispatch queue for delegate
        monitor.start(queue: DispatchQueue(label: "Monitor"))
        monitor.cancel()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),
                           forCellReuseIdentifier: "tableViewCell")
    }
    
    // read the local json file
    // https://programmingwithswift.com/parse-json-from-file-and-url-with-swift/
    private func readLocalData(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    private func fetchData(_ fetchingUrlStr : String) {
        let url = URL(string: fetchingUrlStr)
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            
            guard error == nil else {
                print("Cannot parse data")
                self.alertController(alertType: "Error", alertMessage: error!.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("No data found")
                return
            }
            
            if let recipeData = try? JSONDecoder().decode([Recipe].self, from: data) {
                DispatchQueue.main.async {
                    self.recipes = recipeData
                    self.setUpTableView()
                    self.tableView.reloadData()
                }
            } else {
                NSLog("Failed to fetch data")
                return
            }
        }.resume()
    }
    
//    func loadData() {
//
//        let request = URLRequest(url: URL(string: urlStr)!)
//
//        URLSession.shared.dataTask(with: request) {
//            [weak self] data, response, error in
//            guard let _ = self else { return }
//            if let data = data {
//                DispatchQueue.main.async {
//                    do {
//
//                    } catch {
//
//                    }
//                }
//            } else {
//
//            }
//        }.resume()
//
//        for i in 0...5 {
//
//        }
//    }
    
    
    /* View */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpTableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),
//                           forCellReuseIdentifier: "tableViewCell")

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.networkAvail = "true"
                self.fetchData(self.urlStr)
            } else {
                print("Network not available")
                self.networkAvail = "false"
                if let localData = self.readLocalData(forName: "data") {
                    self.recipes = try! JSONDecoder().decode([Recipe].self, from: localData)
                }
                self.setUpTableView()
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.cancel()
        
//        loadData()
    }

}
