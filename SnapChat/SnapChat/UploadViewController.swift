//
//  UploadViewController.swift
//  SnapChat
//
//  Created by Veysal on 16.10.22.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let storage = Storage.storage()
    let firestoreDB = Firestore.firestore()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(makeAlertAction))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func makeAlertAction(){
        let alert = UIAlertController(title: "Choose an option", message: "", preferredStyle: .actionSheet)
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { _ in
            self.onClickImage(sourceType : .camera)
        }
        let libraryButton = UIAlertAction(title: "Library", style: .default) { _ in
            self.onClickImage(sourceType: .photoLibrary)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cameraButton)
        alert.addAction(libraryButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
     
    func onClickImage (sourceType : UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        self.present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }

    @IBAction func onClickUpload(_ sender: Any) {
        // Storage
        let storageRef = storage.reference()
        let mediaFolder = storageRef.child("Media")
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let id = UUID().uuidString
            let imageRef = mediaFolder.child("\(id).jpg")
            imageRef.putData(data) { _, error in
                if error != nil {
                    self.makeAlert(title:"Error", message: error?.localizedDescription ?? "")
                } else{
                    imageRef.downloadURL { url, error in
                        if error == nil {
                            if let imageUrl = url?.absoluteString as? String {
                                // Firestore
                                self.firestoreDB.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                    if error != nil {
                                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                    } else {
                                        if snapshot?.isEmpty != true {
                                            for document in snapshot!.documents {
                                                let id = document.documentID
                                                if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                    imageUrlArray.append(imageUrl)
                                                    let additioanalArray = ["imageUrlArray":imageUrlArray]
                                                    self.firestoreDB.collection("Snaps").document(id).setData(additioanalArray, merge: true) { error in
                                                        if error != nil {
                                                            self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                                        } else {
                                                            self.tabBarController?.selectedIndex = 0
                                                            self.imageView.image = UIImage(named: "tap")
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            let snaps = ["imageUrlArray" : [imageUrl], "snapOwner" : UserSingleton.sharedUserInfo.username , "date" : Timestamp()]
                                            self.firestoreDB.collection("Snaps").addDocument(data: snaps) { error in
                                                if error != nil {
                                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "")
                                                } else {
                                                    self.tabBarController?.selectedIndex = 0
                                                    self.imageView.image = UIImage(named: "tap")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
