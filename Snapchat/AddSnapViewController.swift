//
//  AddSnapViewController.swift
//  Snapchat
//
//  Created by Mohab Mohamed's on 9/10/19.
//  Copyright © 2019 mohabmohamed. All rights reserved.
//

import UIKit
import FirebaseStorage

class AddSnapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageShow: UIImageView!
    @IBOutlet weak var messageText: UITextField!
    
    var imagePicker : UIImagePickerController?
    
    var snapAdded = false
    var imageName = "\(NSUUID().uuidString).jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
    }
    
    @IBAction func addFromLibrary(_ sender: Any) {
        if imagePicker != nil {
            imagePicker!.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
        
    }
    @IBAction func addByCamera(_ sender: Any) {
         if imagePicker != nil {
            imagePicker?.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageShow.image = image
            snapAdded = true
        }
        dismiss(animated: true, completion: nil )
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if let message = messageText.text{
        if snapAdded &&  message != "" {
            // move to sending view controller
            let snapsFolder = FIRStorage.storage().reference().child("Images")
            
            if let image = imageShow.image{
                if let imgData = image.jpegData(compressionQuality: 0.1){
                    snapsFolder.child(imageName).put(imgData, metadata: nil) { (metadata, error) in
                        if let error = error {
                            self.showAlert(alert: error.localizedDescription)
                        }else {
                            //move to next controller
                            
                            if let downloadURL = metadata?.downloadURL()?.absoluteString {
                                
                                self.performSegue(withIdentifier: "selectContact", sender: downloadURL)
                                
                            }
                            
                        }
                    }
                }
            }
            
        }else {
            // missing image or message
            showAlert(alert: "you must provide both a message and an image")

            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? String{
            if let selectVC = segue.destination as? SelectContactTableViewController {
                selectVC.downloadURL = downloadURL
                selectVC.snapMsg = messageText.text!
                selectVC.snapName = imageName
            }
        }
    }
    
    func showAlert(alert: String){
        
        let alertCont = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alertCont.dismiss(animated: true, completion: nil)
        }
        
        alertCont.addAction(action)
        present(alertCont, animated: true, completion: nil )
    }

    

}
