//
//  ContentViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class ContentViewController: UIViewController {
    
    // TODO: Modify!!!
    // Current Assumptions: steps
    
    var steps : String = ""
    
    // IBOutlet connections for "stepsLabel"
    // Do NOT connect the label now
    // Make sure how the data looks like first!!
    
    // Defines action after pressing "done"
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        // go back to "home"
        if let mainVC = storyboard?.instantiateViewController(withIdentifier: "viewController") as? ViewController {
            self.navigationController?.pushViewController(mainVC, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
