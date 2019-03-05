//
//  ViewController.swift
//  CoreDataSuperExample
//
//  Created by Kevin Yu on 3/5/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit
import CoreData

class GameViewController: UIViewController {
    
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var colorLabel: UITextField!
    @IBOutlet var maxPlayersLabel: UITextField!
    
    var service: CoreDataService!
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGame()
    }
    
    func loadGame() {
        if let g = game {
            nameLabel.text = g.name
            colorLabel.text = g.color
            maxPlayersLabel.text = String(g.maxPlayers)
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
   
        guard let name = nameLabel.text else { return }
        guard let color = colorLabel.text else { return }
        guard let maxPlayersStr = maxPlayersLabel.text, let maxPlayers = Int32(maxPlayersStr) else { return }
        
        updateOrCreateToy(name, color, maxPlayers)
    }
    
    func updateOrCreateToy(_ name: String, _ color: String, _ maxPlayers: Int32) {
   
        let context = service.context
        
        // create a Toy in the context, if there isn't one
        if game == nil {
            game = NSEntityDescription.insertNewObject(forEntityName: "Game",
                                                        into: context) as? Game
        }
        game.name = name
        game.color = color
        //game.maxPlayers = maxPlayers
        
        // save (the Toy in) the context
        service.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        service.deleteObject(game)
        
        nameLabel.text = nil
        colorLabel.text = nil
        maxPlayersLabel.text = nil
        
        navigationController?.popViewController(animated: true)
    }
}

