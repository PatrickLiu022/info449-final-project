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
    
    var viewedRecipeNames : [String] = [] // the recipe names to be saved in "History"
    var favRecipeNames : [String] = [] // the recipe names favorited by user
    
    // Fetch Data
    let monitor = NWPathMonitor()
    let defaultUrl = "https://spoonacular.com/food-api"
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
            
            // TODO: DELETE if qsd
            recipeVC.favButtonTitle = "Save to Fav"
            recipeVC.currRecipeName = recipeNames[indexPath.row]
            recipeVC.doneButtonDestination = "viewController"
            
            
            self.navigationController?.pushViewController(recipeVC, animated: true)
        }
        
        // set fav button title on ContentViewController
        // TODO: FIX!!!!!!!! DELETE see line 68 as well
        if let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController {
            contentVC.favButtonTitle = "Save to Fav"
        }
        
        // updates history record
        //let viewedName = recipes[indexPath.row].recipeName
        let viewedName = recipeNames[indexPath.row] // TODO: DELETE, uncomment above line
        if viewedRecipeNames.contains(viewedName) {
            // remove "viewedName" from record
            viewedRecipeNames = viewedRecipeNames.filter() { $0 != viewedName }
        }
        // add "viewed" name to the front of the array
        viewedRecipeNames.insert(viewedName, at: 0)
        print(viewedRecipeNames)
        
        // TODO: FIX!!!!!!!!
        if let historyVC = storyboard?.instantiateViewController(withIdentifier: "historyViewController") as? HistoryViewController {
            historyVC.historyRecord = "\(viewedRecipeNames)"
            print("DEBUG: \(historyVC.historyRecord)")
        }
        if let favVC = storyboard?.instantiateViewController(withIdentifier: "favViewController") as? FavViewController {
            favVC.favRecipeNames = favRecipeNames
        }
    }
    
    /* Data Fetching Methods */
    
    
    

    /* View */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set up table view on "home" screen
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),
                           forCellReuseIdentifier: "tableViewCell")
        
    }


}

