//
//  SettingsViewController.swift
//  SnapChat
//
//  Created by Veysal on 16.10.22.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func logOutClicked(_ sender: Any) {
        let auth = Auth.auth()
        do {
            try auth.signOut()
            self.performSegue(withIdentifier: "toLoginVC", sender: nil)
        } catch {
            print("Error")
        }
       
    }
    
}
