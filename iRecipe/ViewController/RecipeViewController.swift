//
//  RecipeViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class RecipeViewController: UIViewController {

    var currRecipe : Recipe? = nil
    var tastes : TasteWidget? = nil
    var doneButtonDestination = "" // homeVC or favVC
    
    // for fetching spoonacular API
    let API_KEY = "ed5f10cc83e4459aa76705e7ea396117" // wlimath

    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var tastesLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeToContentVC" {
            if let contentVC = segue.destination as? ContentViewController {
                contentVC.currRecipe = currRecipe
                contentVC.doneButtonDestination = doneButtonDestination
            }
        }
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
            
            if let tasteData = try? JSONDecoder().decode(TasteWidget.self, from: data) {
                DispatchQueue.main.async {
                    self.tastes = tasteData
                    
                    self.tastesLabel.text = "Sweetness: \(self.tastes!.sweetness) \nSaltiness: \(self.tastes!.saltiness) \nSourness: \(self.tastes!.sourness) \nBitterness: \(self.tastes!.bitterness) \nSavoriness: \(self.tastes!.savoriness) \nFattiness: \(self.tastes!.fattiness) \nSpiciness: \(self.tastes!.spiciness)"
                }
            } else {
                print("Failed to fetch data")
                return
            }
        }.resume()
    }
    
    private func fetchImage(_ imageUrl : String) {
        let request = URLRequest(url: URL(string: imageUrl)!)
        
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
            
            if let imageData = data {
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    self.recipeImageView.image = image
                }
            } else {
                print("Failed to fetch image data")
                return
            }
        }.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recipeNameLabel.text = currRecipe!.title
        
        let tasteUrl : String = "https://api.spoonacular.com/recipes/\(self.currRecipe!.id)/tasteWidget.json?apiKey=\(self.API_KEY)"
        self.fetchData(tasteUrl)
        self.fetchImage(self.currRecipe!.image)
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
