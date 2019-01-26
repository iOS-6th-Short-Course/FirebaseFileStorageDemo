//
//  ViewController.swift
//  FirebaseFileStorageDemo
//
//  Created by Chhaileng Peng on 1/26/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import UIKit
import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    @IBAction func browseImageClick(_ sender: Any) {
        let alert = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
            self.pickImage(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.pickImage(sourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func pickImage(sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadClick(_ sender: Any) {
        let reference = Storage.storage().reference().child("/images/\(UUID().uuidString).jpg")
        
        let imageData = UIImage.jpegData(imageView.image!)(compressionQuality: 1)
        
        reference.putData(imageData!, metadata: nil) { (metadata, error) in
            if error == nil {
                print("Success")
                reference.downloadURL(completion: { (url, error) in
                    print("Download URL:", url!)
                })
            } else {
                print("Error")
            }
        }
        
    }
}

