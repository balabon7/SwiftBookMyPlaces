//
//  TableViewController.swift
//  MyPlaces
//
//  Created by mac on 25.05.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var newPlace = Place()
    var imageIsChanged = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.newPlace.savePlaces()
        }
        
        navigationItem.title = "New Place"
        
        //Hide unnecessary table lines
        tableView.tableFooterView = UIView()
        
        saveButton.isEnabled = false
        
        placeName.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    func saveNewPlace(){
        
       // substitute the default picture or custom
        var image: UIImage?
        
        if imageIsChanged {
            image = placeImage.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        //newPlace = Place(name: placeName.text!, location: placeLocation.text, type: placeType.text, image:  image, restaurantImage: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: - Table Field Delegate
extension NewPlaceViewController: UITextFieldDelegate {
    
    //Hide the keyboard by pressing Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: - Table Field Delegate
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

     //Select and edit image
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self // imagePicker делегирует выполнение обязаностей делегату - нашему класу self
            imagePicker.allowsEditing = true // allows you to edit
            imagePicker.sourceType = source // specify the value of source
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Allows the use of a user-edited image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage //(assign the edited image)
        placeImage.contentMode = .scaleAspectFill //scales image by content UIImage
        placeImage.clipsToBounds = true //image border cropping
        
        imageIsChanged = true // indicator default picture or custom
        
        dismiss(animated: true, completion: nil)  //close
    }
    
    @objc private func textFieldChange(){
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
           saveButton.isEnabled = false
        }
    }
    
}
