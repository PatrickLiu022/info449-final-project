//
//  ViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit
import Foundation
import SystemConfiguration


// Convert HTML to NSAttributedString
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /* Variables */
    
    var recipes : [Recipe] = []
    var tastes : TasteWidget? = nil
    var steps : [Step] = []
    
    // for fetching spoonacular API
    let API_KEY = "ea33c7b3439049e4ad95b0a3ca0527c0"
    
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
            recipeVC.indexPathRow = indexPath.row
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
    
    private func fetchTasteData(_ fetchingUrlStr : String) {
        let request = URLRequest(url: URL(string: fetchingUrlStr)!)
        
        URLSession.shared.dataTask(with: request) { [weak self]  data, response, error in
            
            guard let self = self else { return }
            
            guard error == nil else {
                print("Taste Fetching: Cannot parse data")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else {
                print("Taste Fetching: Error with http response")
                return
            }
            
            guard let data = data else {
                print("Taste Fetching: No data found")
                return
            }
            
            if let tasteData = try? JSONDecoder().decode(TasteWidget.self, from: data) {
                DispatchQueue.main.async {
                    self.tastes = tasteData
                    let tasteText = "Sweetness: \(self.tastes!.sweetness) \nSaltiness: \(self.tastes!.saltiness) \nSourness: \(self.tastes!.sourness) \nBitterness: \(self.tastes!.bitterness) \nSavoriness: \(self.tastes!.savoriness) \nFattiness: \(self.tastes!.fattiness) \nSpiciness: \(self.tastes!.spiciness)"
            
                    // save "tasteText" to the singleton
                    RecipeData.instance.recipeTastes.append(tasteText)
                }
            } else {
                print("Taste Fetching: Failed to fetch data")
                return
            }
        }.resume()
    }
    
    private func fetchImageData(_ imageUrl : String) {
        let request = URLRequest(url: URL(string: imageUrl)!)
        
        URLSession.shared.dataTask(with: request) { [weak self]  data, response, error in
            
            guard self != nil else { return }
            
            guard error == nil else {
                print("Image Fetching: Cannot parse data")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else {
                print("Image Fetching: Error with http response")
                return
            }
            
            if let imageData = data {
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    
                    // save "tasteText" to the singleton
                    RecipeData.instance.recipeImages.append(image!)
                }
            } else {
                print("Image Fetching: Failed to fetch image data")
                return
            }
        }.resume()
    }
    
    private func fetchInstructionData(fetchingUrlStr : String, id : Int) {
        let request = URLRequest(url: URL(string: fetchingUrlStr)!)
        
        URLSession.shared.dataTask(with: request) { [weak self]  data, response, error in
            
            guard let self = self else { return }
            
            guard error == nil else {
                print("Instruction Fetching: Cannot parse data")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else {
                print("Instruction Fetching: Error with http response")
                return
            }
            
            guard let data = data else {
                print("Instruction Fetching: No data found")
                return
            }
            
            if let instructionData = try? JSONDecoder().decode([Instruction].self, from: data) {
                DispatchQueue.main.async {
                    self.steps = instructionData[0].steps
                    
                    // save information of all ingredients of the recipe to the singleton
                    var ingredientList : [String] = []
                    for step in self.steps {
                        for ingredient in step.ingredients {
                            ingredientList.append(ingredient.localizedName)
                        }
                    }
                    RecipeData.instance.ingredientLists[id] = ingredientList
                    
                    // save the full step of the recipe to the singleton
                    var fullStep : String = ""
                    for oneStep in self.steps {
                        fullStep += "\(oneStep.step) "
                    }
                    RecipeData.instance.fullSteps[id] = fullStep
                }
            } else {
                print("Instruction Fetching: Failed to fetch data")
                return
            }
        }.resume()
    }
    
    private func fetchNutritionHtml(_ fetchingUrlStr : String) {
        let request = URLRequest(url: URL(string: fetchingUrlStr)!)
        
        URLSession.shared.dataTask(with: request) { [weak self]  data, response, error in
            
            guard self != nil else { return }
            
            guard error == nil else {
                print("Nutrition Fetching: Cannot parse data")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else {
                print("Nutrition Fetching: Error with http response")
                return
            }
            
            // save the nutrition facts html as NSAttributedString in "nutritionAttrTexts" in the singleton
            if let nutritionHtmlData = data {
                DispatchQueue.main.async {
                    let nutritionHtmlText = String(bytes: nutritionHtmlData, encoding: .utf8)
                    let nutritionAttrText = nutritionHtmlText!.html2AttributedString
                    RecipeData.instance.nutritionAttrTexts.append(nutritionAttrText!)
                }
            } else {
                print("Nutrition Fetching: Failed to fetch nutrition html data")
                return
            }
        }.resume()
    }
    
    private func fetchRecipeData(_ fetchingUrlStr : String) {
        let request = URLRequest(url: URL(string: fetchingUrlStr)!)
        
        URLSession.shared.dataTask(with: request) { [weak self]  data, response, error in
            
            guard let self = self else { return }
            
            guard error == nil else {
                print("Nutrition Fetching: Cannot parse data")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else {
                print("Nutrition Fetching: Error with http response")
                return
            }
            
            guard let data = data else {
                print("Nutrition Fetching: No data found")
                return
            }
            
            if let recipeData = try? JSONDecoder().decode([Recipe].self, from: data) {
                DispatchQueue.main.async {
                    self.recipes = recipeData
                    self.recipes.remove(at: 3) // 4th recipe doesn't have "ingredient" data
                    
                    // store each recipe's "id" and "image" information to the singleton
                    for recipe in self.recipes {
                        RecipeData.instance.recipeIds.append(recipe.id)
                        RecipeData.instance.recipeImageUrls.append(recipe.image)
                    }
                    
                    // for each recipe id, fetch for the corresponding recipe's taste and the recipe's instructions; fetching results saved to the singleton
                    for id in RecipeData.instance.recipeIds {
                        // fetching for recipe taste
                        let tasteUrl : String = "https://api.spoonacular.com/recipes/\(id)/tasteWidget.json?apiKey=\(self.API_KEY)"
                        self.fetchTasteData(tasteUrl)
                        
                        // fetching for recipe instructions
                        let instructionUrl = "https://api.spoonacular.com/recipes/\(id)/analyzedInstructions?apiKey=\(self.API_KEY)"
                        self.fetchInstructionData(fetchingUrlStr: instructionUrl, id: id)
                        
                        let nutritionUrl = "https://api.spoonacular.com/recipes/\(id)/nutritionLabel?apiKey=\(self.API_KEY)"
                        self.fetchNutritionHtml(nutritionUrl)
                    }
                    
                    // for each recipe id, fetch for the corresponding recipe's image; fetching results saved to the singleton
                    for imageUrl in RecipeData.instance.recipeImageUrls {
                        self.fetchImageData(imageUrl)
                    }
                    
                    // set up the table view with fetched data
                    self.setUpTableView()
                    self.tableView.reloadData()
                }
            } else {
                print("Nutrition Fetching: Failed to fetch data")
                return
            }
        }.resume()
    }
    
    
    /* View */
    
    func internetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func fireAlert(alertTitle : String, alertMessage : String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: {
            NSLog("\(alertTitle) fired")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // look for recipes with 10 <= carb <= 50
        let recipeUrl = "https://api.spoonacular.com/recipes/findByNutrients?minCarbs=10&maxCarbs=50&number=7&apiKey=\(self.API_KEY)"
        
        // check network
        if self.internetAvailable() { // connected to network
            self.fireAlert(alertTitle: "Welcome", alertMessage: "Ready to go!")
            
            // fetch for recipe data; fetching results saved to the singleton
            self.fetchRecipeData(recipeUrl)
        } else { // network not available
            self.fireAlert(alertTitle: "Network not available", alertMessage: "Please check your network")
        }
    }
}
