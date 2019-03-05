//
//  ToyTableViewController.swift
//  CoreDataSuperExample
//
//  Created by Kevin Yu on 3/5/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class ToyTableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var toys = [Toy]()
    var games = [Game]()
    
    var service = CoreDataService()
    
    var searchStr = ""
    
    var displayType: SearchViewController.DisplayType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadAll()
    }
    
    func loadAll() {
        
        //Note to Kevin: I am using a generic function here.
        
        toys = service.loadAllEntities(named: "Toy")
        games = service.loadAllEntities(named: "Game")
        
        tableView.reloadData()
    }
    
    
    func setSearch(_ str: String?, displayType: SearchViewController.DisplayType){
        
        self.displayType = displayType
        
        if let s = str{
            if s != ""{
                if displayType != .games{
                    toys = service.findAllEntities(named: "Toy", searchFor: s)
                }
                if displayType != .toys{
                    games = service.findAllEntities(named: "Game", searchFor: s)
                }
                tableView.reloadData()
                searchStr = s
                return
            }
        }
        searchStr = ""
        loadAll()
        
        if displayType == .games{
            toys = []
        }
        if displayType == .toys{
            games = []
        }

        tableView.reloadData()
        
    }

    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "toyDetails":
            let vc = segue.destination as! ToyViewController
            vc.myToy = sender as? Toy
            vc.service = service
        case "createToy":
            let vc = segue.destination as! ToyViewController
            vc.service = service
        case "showEditGame":
            let vc = segue.destination as! GameViewController
            vc.game = sender as? Game
            vc.service = service
        case "showAddGame":
            let vc = segue.destination as! GameViewController
            vc.service = service
        case "showSearch":
            let dest = segue.destination as! SearchViewController
            dest.searchStr = searchStr
            dest.displayType = displayType
            dest.delegate = self
        default:
            return
        }
    }
}

extension ToyTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return toys.count
        }else{
            return games.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        
        if indexPath.section == 0{
            cell.textLabel?.text = toys[indexPath.row].name
            cell.backgroundColor = UIColor.green
        }else{
            cell.textLabel?.text = games[indexPath.row].name
            cell.backgroundColor = UIColor.cyan
        }
        return cell
    }
}

extension ToyTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            self.performSegue(withIdentifier: "toyDetails",
                          sender: toys[indexPath.row])
        }else{
            self.performSegue(withIdentifier: "showEditGame", sender: games[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if(indexPath.section == 0){
                service.deleteObject(toys[indexPath.row])
                loadAll()
            }else{
                service.deleteObject(games[indexPath.row])
                loadAll()
            }
        }
    }
}
