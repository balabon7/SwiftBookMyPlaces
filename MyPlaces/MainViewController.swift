//
//  ViewController.swift
//  MyPlaces
//
//  Created by mac on 25.05.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    let places = Place.getPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Places"
    }

    
    //MARK: - UItableView Protocols
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
     }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.nameLabel?.text = places[indexPath.row].name
        cell.locationLabel?.text = places[indexPath.row].location
        cell.TypeLabel?.text = places[indexPath.row].type
        cell.imageOfPlace?.image = UIImage(named: places[indexPath.row].image)
        
        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace?.clipsToBounds = true
        
        return cell
     }
    
    @IBAction func cancelAction(_ segue: UIStoryboardSegue){ }
    
}

