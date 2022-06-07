//
//  SearchViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class SearchTableDataSource: NSObject, UITableViewDataSource {
    
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

class SearchViewController: UIViewController, UITableViewDelegate {
    
    var searchTableDataSource = SearchTableDataSource()

    var allRecipes : [Recipe] = []
    var searchResults : [Recipe] = []
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    
    func searchRecipes(_ searchStr : String) {
        for recipe in allRecipes { //&& !searchResults.contains(recipe)
            if recipe.title.lowercased().range(of: searchStr.lowercased()) != nil { // exists recipes whose names contain the search string
                searchResults.append(recipe)
            }
        }
    }

    @IBAction func checkButtonPressed(_ sender: UIButton) {
        let searchStr = searchTextField.text
        if searchStr != "" {
            searchRecipes(searchStr!)
        } else {
            let alert = UIAlertController(title: "Empty input", message: "Please give a name to search on", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: {
                NSLog("Notification fired")
            })
        }

        if searchResults.count == 0 { // no results found
            noResultLabel.isHidden = false
        } else { // display results
            searchTableDataSource.results = searchResults
            searchTableView.dataSource = searchTableDataSource
            searchTableView.reloadData()

            noResultLabel.isHidden = true
        }

        dismissButton.isHidden = false
        checkButton.isEnabled = false
        searchTextField.isEnabled = false
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        // clean search results
        searchResults = []

        // clean table
        searchTableDataSource.results = []
        searchTableView.reloadData()

        dismissButton.isHidden = true
        noResultLabel.isHidden = true
        searchTextField.isEnabled = true
        checkButton.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // connects to RecipeViewController
        if let recipeVC = storyboard?.instantiateViewController(withIdentifier: "recipeViewController") as? RecipeViewController {
            recipeVC.currRecipe = searchResults[indexPath.row]
            recipeVC.indexPathRow = indexPath.row
            recipeVC.doneButtonDestination = "viewController"
            self.navigationController?.pushViewController(recipeVC, animated: true)
        }

        // updates history record
        let viewedRecipeName = searchResults[indexPath.row].title
        ViewHistory.instance.updatesHistory(viewedRecipeName)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchTableView.delegate = self
        searchTableView.register(UINib(nibName: "TableViewCell", bundle: nil),
                           forCellReuseIdentifier: "tableViewCell")

        searchTextField.text = ""
        searchTextField.placeholder = "Type in a recipe name here"
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
