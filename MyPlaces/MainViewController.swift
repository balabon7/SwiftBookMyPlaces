//
//  ViewController.swift
//  MyPlaces
//
//  Created by mac on 25.05.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
    
    var places: Results<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Places"
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Snell Roundhand", size: 20)!]
        
        places = realm.objects(Place.self)
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super .viewWillAppear(true)
//
//    }
    
    //MARK: - UITableView Protocols
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
     }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = places[indexPath.row]
        
        cell.nameLabel?.text = place.name
        cell.locationLabel?.text = place.location
        cell.TypeLabel?.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        
        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace?.clipsToBounds = true
        
        return cell
     }
    
    //MARK: - UITableView Delegate
    
    // delete value and cell
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let place = places[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            
            StorageManager.deletePbject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
     
            let place = places[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        newPlaceVC.savePlace()
    
        tableView.reloadData()
    }
}

