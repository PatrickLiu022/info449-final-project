//
//  HistoryViewController.swift
//  iRecipe
//
//  Created by Helen Li on 5/30/22.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var historyRecord = "No History"

    @IBOutlet weak var historyLabel: UILabel!
    
    func setHistoryLabel() {
        let currHistory = ViewHistory.instance.viewedRecipeNames
        if currHistory.count > 0 {
            historyRecord = "\(currHistory)"
        }
        historyLabel.text = "\(historyRecord)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setHistoryLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setHistoryLabel()
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
