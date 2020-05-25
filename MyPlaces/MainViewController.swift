//
//  ViewController.swift
//  MyPlaces
//
//  Created by mac on 25.05.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
 
    let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Places"
    }

    
    //MARK: - UItableView Protocols
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
     }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.nameLabel?.text = restaurantNames[indexPath.row]
        cell.imageOfPlace?.image = UIImage(named: restaurantNames[indexPath.row])
        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace?.clipsToBounds = true
        return cell
     }
    
}

