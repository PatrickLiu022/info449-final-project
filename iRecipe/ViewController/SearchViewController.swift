//
//  SearchViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var allRecipes : [Recipe] = []
    var searchedResults : [Recipe] = []
    
    var allRecipeNames : [String] = [] // TODO: change it to allRecipes.forEach(grab recipeName)
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    @IBOutlet weak var searchTableView: UITableView!
    
    
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        let searchInput = searchTextField.text
        let validNames = allRecipeNames.filter() { name in
            return name.contains(searchInput!)
        }

        searchedResults = allRecipes.filter() { recipe in
            return validNames.contains(recipe.recipeName)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        cell.recipeNameLabel.text = searchedResults[indexPath.row].recipeName
        cell.recipeDescLabel.text = searchedResults[indexPath.row].recipeDesc

        return cell
    }
    
    // Defines the number of table cells being displayed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedResults.count
    }
    
    // Defines the height of each table cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let recipeVC = storyboard?.instantiateViewController(withIdentifier: "recipeViewController") as? RecipeViewController {
            recipeVC.currRecipeName = searchedResults[indexPath.row].recipeName
            self.navigationController?.pushViewController(recipeVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib(nibName: "TableViewCell", bundle: nil),
                           forCellReuseIdentifier: "tableViewCell")
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
