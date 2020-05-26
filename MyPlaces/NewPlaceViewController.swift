//
//  TableViewController.swift
//  MyPlaces
//
//  Created by mac on 25.05.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    @IBOutlet weak var imageOfPlace: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New Place"
        
        //Hide unnecessary table lines
        tableView.tableFooterView = UIView()
        
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
        imageOfPlace.image = info[.editedImage] as? UIImage //(assign the edited image)
        imageOfPlace.contentMode = .scaleAspectFill //scales image by content UIImage
        imageOfPlace.clipsToBounds = true //image border cropping
        dismiss(animated: true, completion: nil)  //close
    }
}
