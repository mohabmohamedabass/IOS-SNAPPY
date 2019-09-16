//
//  SnapsTableViewController.swift
//  Snapchat
//
//  Created by Mohab Mohamed's on 9/10/19.
//  Copyright © 2019 mohabmohamed. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsTableViewController: UITableViewController {

    
    var snaps : [FIRDataSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUserId = FIRAuth.auth()?.currentUser?.uid{
            
            FIRDatabase.database().reference().child("Users").child(currentUserId).child("snaps").observe(.childAdded) { (snapshot) in
                
                self.snaps.append(snapshot)
                self.tableView.reloadData()
                
                
                FIRDatabase.database().reference().child("Users").child(currentUserId).child("snaps").observe(.childRemoved, with: { (snapshot) in
                    var index = 0
                    
                    for snap in self.snaps {
                        if snapshot.key == snap.key{
                            self.snaps.remove(at: index)
                        }
                        index += 1
                    }
                    self.tableView.reloadData()
                })
            }
        }

    }

    @IBAction func logoutPressed(_ sender: Any) {
        try? FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if snaps.count == 0 {
             return 1
        }else{
             return snaps.count
        }
        
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if snaps.count == 0 {
            cell.textLabel?.text = "No Snaps Yet."
        }else{
        
        let snap = snaps[indexPath.row]
        
        if let snapsDict = snap.value as? NSDictionary {
            if let senderEmail = snapsDict["from"] as? String{
                cell.textLabel?.text = senderEmail
            }
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let snap = snaps[indexPath.row]
        
         performSegue(withIdentifier: "viewSnap", sender: snap )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnap"{
            if let snapViewVC = segue.destination as? SnapViewController {
                if let snap = sender as? FIRDataSnapshot {
                    snapViewVC.snap = snap 
                }
            }
        }
    }

}
