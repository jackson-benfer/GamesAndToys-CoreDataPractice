//
//  SearchViewController.swift
//  CoreDataSuperExample
//
//  Created by MAC Consultant on 3/5/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    weak var delegate: ToyTableViewController?
    
    @IBOutlet var textField: UITextField!
    
    var searchStr: String?
    
    var displayType = DisplayType.all
    
    enum DisplayType: Int{
        case all = 0, toys, games
    }
    
    @IBOutlet var button: UISegmentedControl!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        textField.text = searchStr
        button.selectedSegmentIndex = displayType.rawValue
    }
    

    @IBAction func onButtonPress(_ sender: Any) {
        leave()
    }
    
    @IBAction func onSearch(_ sender: Any) {
        if let d = delegate{
            
            d.setSearch(textField.text, displayType: DisplayType(rawValue: button.selectedSegmentIndex) ?? DisplayType.all)
        }
        
    }
    
    func leave(){
        
        UIView.animate(withDuration: 0.3,
        
            animations: {
                self.view.alpha = 0
            },
        
            completion:{ b in
                self.dismiss(animated: false, completion: nil)
            })
        
    }
    
    
}
