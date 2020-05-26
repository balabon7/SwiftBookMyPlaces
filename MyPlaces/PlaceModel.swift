//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by mac on 25.05.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import RealmSwift

class Place: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic  var imageData: Data?

    let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]
    
    func savePlaces(){
        for place in restaurantNames {
            let image = UIImage(named: place)
            guard let imageData = image?.pngData() else { return }
  
            let newPlace = Place()
            
            newPlace.name = place
            newPlace.location = "Уфа"
            newPlace.type = "Ресторан"
            newPlace.imageData = imageData
            
            StorageManager.saveObject(newPlace)
        }

    }
}
