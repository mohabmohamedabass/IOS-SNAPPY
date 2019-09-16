 //
//  SnapViewController.swift
//  Snapchat
//
//  Created by Mohab Mohamed's on 9/15/19.
//  Copyright © 2019 mohabmohamed. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import FirebaseAuth
import FirebaseStorage

class SnapViewController: UIViewController {

    @IBOutlet weak var snapView: UIImageView!
    
    @IBOutlet weak var snapTextLabel: UILabel!
    
    var snapName = " "
    
    var snap : FIRDataSnapshot? 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let snapsDict = snap?.value as? NSDictionary {
            if let snapMessage = snapsDict["snapmessage"] as? String{
                if let snapURL = snapsDict["imageURL"] as? String{
                    snapTextLabel.text = snapMessage
                    
                    if let url = URL(string: snapURL){
                        snapView.sd_setImage(with: url)
                    }
                    if let snapName = snapsDict["imagename"] as? String{
                        self.snapName = snapName
                    }
                }
                
            }
        }
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        if let currentUserID = FIRAuth.auth()?.currentUser?.uid{
            if let snapkey = snap?.key{
            FIRDatabase.database().reference().child("Users").child(currentUserID).child("snaps").child(snapkey).removeValue()
                
            FIRStorage.storage().reference().child("Images").child(snapName).delete(completion: nil)
            }
        }
    }

}
