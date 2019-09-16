//
//  SelectContactTableViewController.swift
//  Snapchat
//
//  Created by Mohab Mohamed's on 9/12/19.
//  Copyright © 2019 mohabmohamed. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SelectContactTableViewController: UITableViewController {
    
    var snapMsg = ""
    var downloadURL = " "
    var snapName = " "
    var usersArr : [User] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRDatabase.database().reference().child("Users").observe(.childAdded) { (snapshot) in
            let user = User()
            if let userDict = snapshot.value as? NSDictionary {
                if let email = userDict["email"] as? String{
                    user.email = email
                    user.uid = snapshot.key
                    self.usersArr.append(user)
                    self.tableView.reloadData()
                }
            }
                
            
        }
        
    }


    // MARK: - Table view data source

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let user = usersArr[indexPath.row]
        cell.textLabel?.text = user.email
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = usersArr[indexPath.row]
        
        if let senderEmail = FIRAuth.auth()?.currentUser?.email{
            let snaps = ["from":senderEmail, "snapmessage":snapMsg, "imageURL":downloadURL, "imagename":snapName]
            
            FIRDatabase.database().reference().child("Users").child(user.uid).child("snaps").childByAutoId().setValue(snaps)
            
            navigationController?.popToRootViewController(animated: true )
        }

    }
} 

class User {
    var email = ""
    var uid = ""
}
