//
//  ViewController.swift
//  Snapchat
//
//  Created by Mohab Mohamed's on 9/2/19.
//  Copyright © 2019 mohabmohamed. All rights reserved.
/*<div>Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/"     title="Flaticon">www.flaticon.com</a></div>*/

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginFirstButton: UIButton!
    @IBOutlet weak var signupFirstButton: UIButton!
    
    var signupMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func firstButtonPressed(_ sender: Any) {
        if let email = emailText.text {
            if let password = passwordText.text{
                if signupMode{
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            self.showAlert(alert: error.localizedDescription)
                        }else{
                            print("Sign Up was successful.")
                            if let user = user {
                                FIRDatabase.database().reference().child("Users").child(user.uid).child("email").setValue(user.email)
                                self.performSegue(withIdentifier: "movesToSnaps", sender: nil)  
                            }
                            
                            
                        }
                    })
                }else{
                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            self.showAlert(alert: error.localizedDescription)
                        }else{
                            print("Log In was successful.")
                            self.performSegue(withIdentifier: "movesToSnaps", sender: nil)
                        }
                    })
                }
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
    
    @IBAction func secondButtonPressed(_ sender: Any) {
        if signupMode {
            // log in mode
            signupMode = false
            loginFirstButton.setTitle("Log In ", for: .normal)
            signupFirstButton.setTitle("Go to Sign Up", for: .normal)
            
        }else{
            //sign up mode
            signupMode = true
            loginFirstButton.setTitle("Sign Up ", for: .normal)
            signupFirstButton.setTitle("Go to Log In", for: .normal)
            
        }
    }
    
}

