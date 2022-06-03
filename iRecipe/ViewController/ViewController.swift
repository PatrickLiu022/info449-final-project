//
//  ViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit
import Network

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /* Variables */
    
    // Data
    //let recipes : [Recipe] = []
    let recipeNames = ["recipe1 for testing", "recipe2 for testing", "recipe3 for testing", "recipe4 for testing", "recipe5 for testing", "recipe16 for testing"]  // TODO: DELETE, uncommet above line
    let recipeDescs = ["desc for testing recipe1", "desc for testing recipe2", "desc for testing recipe3", "desc for testing recipe4", "desc for testing recipe5", "desc for testing recipe6"] // TODO: DELETE
    
    
    // TODO: Fix Next
    var favRecipeNames : [String] = [] // the recipe names favorited by user
    
    
    
    
    // Fetch Data
    let monitor = NWPathMonitor()
    let defaultUrl = "https://api.spoonacular.com/recipes/random?apiKey=f130ece44f9f4817a32b8aaa54c596d1"
    var fetchingUrl = ""
    
    // Network
    var networkAvail = "false" // a boolean reflecting whether network is available
    
    // UI Connections
    @IBOutlet weak var tableView: UITableView!
    
    
    /* Table View Methods */
    
    // Defines each table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        //cell.recipeNameLabel.text = recipes[indexPath.row].recipeName
        cell.recipeNameLabel.text = recipeNames[indexPath.row] // TODO: DELETE, uncommet above line
        
        //cell.recipeDescLabel.text = recipes[indexPath.row].recipeDesc
        cell.recipeDescLabel.text = recipeDescs[indexPath.row] // TODO: DELETE, uncommet above line

        return cell
    }
    
    // Defines the number of table cells being displayed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return recipes.count
        return recipeNames.count // TODO: DELETE, uncommet above line
    }
    
    // Defines the height of each table cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    // Defines action of each table cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // connects to RecipeViewController
        if let recipeVC = storyboard?.instantiateViewController(withIdentifier: "recipeViewController") as? RecipeViewController {
            //recipeVC.recipes = recipes
            recipeVC.recipeNames = recipeNames // TODO: DELETE, uncommet above line
            recipeVC.indexPathRow = indexPath.row
            
            // TODO: do NOT delete this!!
            recipeVC.favButtonTitle = "Save to Fav"
            recipeVC.currRecipeName = recipeNames[indexPath.row]
            recipeVC.doneButtonDestination = "viewController"
            
            self.navigationController?.pushViewController(recipeVC, animated: true)
        }
        
        // TODO: Fix Next
        // set fav button title on ContentViewController
//        if let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController {
//            contentVC.favButtonTitle = "Save to Fav"
//        }
        
        
        
        
        // updates history record
        //let viewedName = recipes[indexPath.row].recipeName
        let viewedRecipeName = recipeNames[indexPath.row] // TODO: DELETE, uncomment above line
        ViewHistory.instance.updatesHistory(viewedRecipeName)

        
        
//        // TODO: Fix Next
//        if let favVC = storyboard?.instantiateViewController(withIdentifier: "favViewController") as? FavViewController {
//            favVC.favRecipeNames = favRecipeNames
//        }
    }
    
    /* Data Fetching Methods */
    
    func loadData() {
        let request = URLRequest(url: URL(string: defaultUrl)!)
        // TODO: above line will cause app to crash
        URLSession.shared.dataTask(with: request) {
            [weak self] data, response, error in
            guard let _ = self else { return }
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        
                    } catch {
                        
                    }
                }
            } else {
                
            }
        }.resume()
        
        for i in 0...5 {
            
        }
    }
    
    
    
    /* View */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set up table view on "home" screen
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),
                           forCellReuseIdentifier: "tableViewCell")
        loadData()
        
    }

}

