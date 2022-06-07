//
//  ViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit
import Network
import Foundation

// Convert HTML to Plain Text
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

//extension String {
//    var htmlToAttributedString: NSAttributedString? {
//        guard let data = data(using: .utf8) else { return nil }
//        do {
//            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            return nil
//        }
//    }
//
//    var htmlToString: String {
//        return htmlToAttributedString?.string ?? ""
//    }
//}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /* Variables */
    
    var recipes : [Recipe] = []
    var tastes : TasteWidget? = nil
    var steps : [Step] = []
    
    // for fetching spoonacular API
    let API_KEY = "ed5f10cc83e4459aa76705e7ea396117" // wlimath

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
            recipeVC.indexPathRow = indexPath.row
            recipeVC.doneButtonDestination = "viewController"
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
                    let tasteText = "Sweetness: \(self.tastes!.sweetness) \nSaltiness: \(self.tastes!.saltiness) \nSourness: \(self.tastes!.sourness) \nBitterness: \(self.tastes!.bitterness) \nSavoriness: \(self.tastes!.savoriness) \nFattiness: \(self.tastes!.fattiness) \nSpiciness: \(self.tastes!.spiciness)"
            
                    // save "tasteText" to the singleton
                    RecipeData.instance.recipeTastes.append(tasteText)
                }
            } else {
                print("Failed to fetch data")
                return
            }
        }.resume()
    }
    
    private func fetchImageData(_ imageUrl : String) {
        let request = URLRequest(url: URL(string: imageUrl)!)
        
        URLSession.shared.dataTask(with: request) { [weak self]  data, response, error in
            
            guard self != nil else { return }
            
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
                    
                    // save "tasteText" to the singleton
                    RecipeData.instance.recipeImages.append(image!)
                }
            } else {
                print("Failed to fetch image data")
                return
            }
        }.resume()
    }
    
    private func fetchInstructionData(fetchingUrlStr : String, id : Int) {
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
                print("Failed to fetch data")
                return
            }
        }.resume()
    }
    
    private func fetchNutritionHtml(_ fetchingUrlStr : String) {
        let request = URLRequest(url: URL(string: fetchingUrlStr)!)
        
        URLSession.shared.dataTask(with: request) { [weak self]  data, response, error in
            
            guard self != nil else { return }
            
            guard error == nil else {
                print("Cannot parse data")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else {
                print("Error with http response")
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
                print("Failed to fetch nutrition html data")
                return
            }
        }.resume()
    }
    
    private func fetchRecipeData(_ fetchingUrlStr : String) {
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
                
                // fetch for recipe data; fetching results saved to the singleton
                self.fetchRecipeData(recipeUrl)
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
    
    func fireAlert(alertTitle : String, alertMessage : String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: {
            NSLog("\(alertTitle) fired")
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fireAlert(alertTitle: "Welcome", alertMessage: "Ready to go!")
    }

//    // TODO: handle local
//    override func viewWillAppear(_ animated: Bool) {
//        if !networkAvail {
//            self.fireAlert(alertTitle: "Network not available", alertMessage: "Please connect to a network")
//        }
//    }
}
