//
//  FavViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class FavViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //let favRecipes : [Recipe] = []
    var favRecipeNames = ["fav recipe 1", "fav recipe 2", "fav recipe 3", "fav recipe 4"] // TODO: DELETE, uncomment above
    var favRecipeDescs = ["description 1", "description 2", "description 3", "description 4"] // TODO: DELETE

    
    
    @IBOutlet weak var favTableView: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        //cell.recipeNameLabel.text = favRecipes[indexPath.row].recipeName
        cell.recipeNameLabel.text = favRecipeNames[indexPath.row] // TODO: DELETE, uncommet above line
        
        //cell.recipeDescLabel.text = favRecipes[indexPath.row].recipeDesc
        cell.recipeDescLabel.text = favRecipeDescs[indexPath.row] // TODO: DELETE, uncommet above line

        return cell
    }
    
    // Defines the number of table cells being displayed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return favRecipes.count
        return favRecipeNames.count // TODO: DELETE, uncommet above line
    }
    
    // Defines the height of each table cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let recipeVC = storyboard?.instantiateViewController(withIdentifier: "recipeViewController") as? RecipeViewController {
            recipeVC.currRecipeName = favRecipeNames[indexPath.row]
            recipeVC.doneButtonDestination = "favViewController"
            self.navigationController?.pushViewController(recipeVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favTableView.delegate = self
        favTableView.dataSource = self
        favTableView.register(UINib(nibName: "TableViewCell", bundle: nil),
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
