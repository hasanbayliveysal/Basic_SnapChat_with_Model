//
//  FeedViewController.swift
//  SnapChat
//
//  Created by Veysal on 16.10.22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var snapArray = [SnapsModel]()
    var choosenSnap : SnapsModel?
    let firestoreDB = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfo()
        getSnapsFromFirebase()
        tableView.delegate = self
        tableView.dataSource = self
        
        print("SnapsArray : \(snapArray)")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedsTableViewCell
        cell.usernameLabel.text = snapArray[indexPath.row].username
        cell.snapsImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].userSnaps[0]))
        return cell
    }

    
    func getUserInfo() {
        firestoreDB.collection("UserInfo").whereField("email", isEqualTo: currentUser!.email!).getDocuments { snapshot, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                        if let userName = document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = self.currentUser!.email!
                            UserSingleton.sharedUserInfo.username = userName
                        }
                    }
                }
            }
        }
    }
    
    func getSnapsFromFirebase() {
        firestoreDB
            .collection("Snaps")
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else{
                    if snapshot?.isEmpty != true {
                        self.snapArray.removeAll()
                        for document in snapshot!.documents {
                            let id = document.documentID
                            if let username = document.get("snapOwner") as? String {
                                if let usersnap = document.get("imageUrlArray") as? [String] {
                                    if let date = document.get("date") as? Timestamp {
                                        
                                        if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                            if difference >= 24 {
                                                self.firestoreDB.collection("Snaps").document(id).delete()
                                            }else {
                                                //TimeLeft -> DetailsViewController
                                                let snap = SnapsModel(username: username, userSnaps: usersnap, date: date.dateValue(), timeDifference: 24 - difference)
                                                self.snapArray.append(snap)
                                            }
                                                
                                           
                                        }
                                    }
                                }
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        print("SnapsArray : \(self.snapArray)")
       }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.selectedSnap = choosenSnap
        }
    }
   
}


extension UIViewController {
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
