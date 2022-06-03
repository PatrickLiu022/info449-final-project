//
//  FavViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class FavViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var favTableView: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        
        // TODO: Modify after fetching
        //cell.recipeNameLabel.text = FavRecipes.instance.favRecipes[indexPath.row].recipeName
        //cell.recipeDescLabel.text = FavRecipes.instance.favRecipes[indexPath.row].recipeDesc
        cell.recipeNameLabel.text = FavRecipes.instance.favRecipeNames[indexPath.row]
        
        return cell
    }
    
    // Defines the number of table cells being displayed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Modify after fetching
        //return FavRecipes.instance.favRecipes.count
        return FavRecipes.instance.favRecipeNames.count
    }
    
    // Defines the height of each table cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let recipeVC = storyboard?.instantiateViewController(withIdentifier: "recipeViewController") as? RecipeViewController {
            
            // TODO: Modify after fetching
            //recipeVC.currRecipe = FavRecipes.instance.favRecipes[indexPath.row]
            recipeVC.currRecipeName = FavRecipes.instance.favRecipeNames[indexPath.row]
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favTableView.reloadData()
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
