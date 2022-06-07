//
//  RecipeData.swift
//  iRecipe
//
//  Created by Helen Li on 6/6/22.
//

import Foundation
import UIKit
import Network


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


class RecipeData {

    static let instance = RecipeData()
    
    var recipes : [Recipe] = [] // an array of all Recipes
//    var recipesLocal : [RecipeLocal] = []
    
    // for accessing ViewController's setUpTableView() method
    weak var vc : ViewController?
    
    // for fetching
    var recipeGenInfo : [RecipeGenInfo] = []
    var tasteWidget : TasteWidget? = nil
    var steps : [Step] = []
    
    // for fetching spoonacular API
    let API_KEY = "ae80e31ccb4140e1905c5b890ef97d25" // helenli03
    
    // Network
    let monitor = NWPathMonitor()
    var networkAvail : Bool = false
    
    private func fetchTasteData(index: Int, fetchingUrl: String) {
        let request = URLRequest(url: URL(string: fetchingUrl)!)
        
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
                    self.tasteWidget = tasteData
                    
                    let tastesText = "Sweetness: \(self.tasteWidget!.sweetness) \nSaltiness: \(self.tasteWidget!.saltiness) \nSourness: \(self.tasteWidget!.sourness) \nBitterness: \(self.tasteWidget!.bitterness) \nSavoriness: \(self.tasteWidget!.savoriness) \nFattiness: \(self.tasteWidget!.fattiness) \nSpiciness: \(self.tasteWidget!.spiciness)"
                    self.recipes[index].addTastes(tastesText)
                }
            } else {
                print("Failed to fetch data")
                return
            }
        }.resume()
    }
    
    private func fetchImageData(index: Int, fetchingUrl: String) {
        let request = URLRequest(url: URL(string: fetchingUrl)!)
        
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
                    self!.recipes[index].addImage(image!)
                }
            } else {
                print("Failed to fetch image data")
                return
            }
        }.resume()
    }
    
    private func fetchInstructionData(index: Int, fetchingUrl: String) {
        let request = URLRequest(url: URL(string: fetchingUrl)!)
        
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
                    
                    for step in self.steps {
                        for ingredient in step.ingredients {
                            self.recipes[index].addIngredients(ingredient.localizedName)
                        }
                    }
                    
                    // save the full step of the recipe to the singleton
                    var allSteps : String = ""
                    for oneStep in self.steps {
                        allSteps += "\(oneStep.step) "
                    }
                    self.recipes[index].addInstruction(allSteps)
                }
            } else {
                print("Failed to fetch data")
                return
            }
        }.resume()
    }
    
    private func fetchNutritionHtml(index: Int, fetchingUrl: String) {
        let request = URLRequest(url: URL(string: fetchingUrl)!)
        
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
                    
                    self!.recipes[index].addNutrAttrText(nutritionAttrText!)
                }
            } else {
                print("Failed to fetch nutrition html data")
                return
            }
        }.resume()
    }
    
    private func fetchRecipeData(_ fetchingUrl : String) {
        let request = URLRequest(url: URL(string: fetchingUrl)!)
        
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
            
            if let recipeData = try? JSONDecoder().decode([RecipeGenInfo].self, from: data) {
                DispatchQueue.main.async {
                    self.recipeGenInfo = recipeData
                    self.recipeGenInfo.remove(at: 3) // 4th recipe doesn't have "ingredient" data
                
                    // constructs 6 Recipe objects and store them in "recipes"
                    for info in self.recipeGenInfo {
                        self.recipes.append(Recipe(recipeId: info.id, recipeName: info.title, recipeImageUrl: info.image, recipeCalories: info.calories))
                    }
                    
                    // for each Recipe in the "recipes" array
                    var currIndex = 0
                    for recipe in self.recipes {
                        
                        // fetching recipe taste
                        let tasteUrl : String = "https://api.spoonacular.com/recipes/\(recipe.id)/tasteWidget.json?apiKey=\(self.API_KEY)"
                        self.fetchTasteData(index: currIndex, fetchingUrl: tasteUrl)
                        
                        // fetch image
                        self.fetchImageData(index: currIndex, fetchingUrl: recipe.imageUrl)
                        
                        // fetch instruction
                        let instructionUrl = "https://api.spoonacular.com/recipes/\(recipe.id)/analyzedInstructions?apiKey=\(self.API_KEY)"
                        self.fetchInstructionData(index: currIndex, fetchingUrl: instructionUrl)
                        
                        // fetch nutrition
                        let nutritionUrl = "https://api.spoonacular.com/recipes/\(recipe.id)/nutritionLabel?apiKey=\(self.API_KEY)"
                        self.fetchNutritionHtml(index: currIndex, fetchingUrl: nutritionUrl)
                    
                        currIndex += 1
                    }
                    
                    // set up the "home" table view and make it load
                    self.vc!.setUpTableView()
                    self.vc!.tableView.reloadData()
                }
            } else {
                print("Failed to fetch data")
                return
            }
        }.resume()
    }
    
    private func readLocalJson(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func dataSetUp() {
        // check network
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied { // connected to network
                self.networkAvail = true
                
                // look for recipes with 10 <= carb <= 50
                let recipeUrl = "https://api.spoonacular.com/recipes/findByNutrients?minCarbs=10&maxCarbs=50&number=7&apiKey=\(self.API_KEY)"
                
                // fetch data
                self.fetchRecipeData(recipeUrl)
            } else { // network not available
                self.networkAvail = false

//                // load local data
//                if let localData = self.readLocalJson(forName: "data") {
//                    self.recipes = try! JSONDecoder().decode([RecipeLocal].self, from: localData)
//                }
//                self.vc!.setUpTableView()
            }
        }

        // set up dispatch queue for delegate
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.cancel()
    }
}
