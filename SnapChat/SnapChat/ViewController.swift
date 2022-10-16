//
//  ViewController.swift
//  SnapChat
//
//  Created by Veysal on 15.10.22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    let auth = Auth.auth()
    let firestoreDB = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    @IBAction func singInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            auth.signIn(withEmail: emailText.text!, password: passwordText.text!) { _, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else {
            self.makeAlert(title: "Error", message: "Email / Password ?")
        }
    }
    
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" && usernameText.text != "" {
            auth.createUser(withEmail: emailText.text! , password: passwordText.text!) { _, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    let userInfo = ["email": self.emailText.text!, "username": self.usernameText.text! ]
                    self.firestoreDB.collection("UserInfo").addDocument(data: userInfo) { error in
                        if error != nil {
                            print("Error accured")
                            self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                        } else {
                            print("Saved Successful")
                        }
                    }
                }
            }
        } else {
            self.makeAlert(title: "Error", message: "Username / Email / Password ?")
        }
       
    }
    
   
}

