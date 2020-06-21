//
//  ImageViewController.swift
//  Notes
//
//  Created by Richa Patel on 2020-06-20.
//  Copyright © 2020 Simranjot singh. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation
import Photos
import AVFoundation
import MediaPlayer

class ImageViewController:  UIViewController, CLLocationManagerDelegate, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UNUserNotificationCenterDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate  {

    @IBOutlet var selectedImage: UIImageView!
    @IBOutlet var removeImageBtn: UIButton!
    
    
     var imageData = Data()
    override func viewDidLoad() {
        super.viewDidLoad()
   openDialog()
        // Do any additional setup after loading the view.
    }
    
    
      func openDialog(){
          let alert = UIAlertController(title: "Select an image!", message: "Pick image from", preferredStyle: .actionSheet)
          
          
          
          alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
              
              if UIImagePickerController.isSourceTypeAvailable(.camera) {
                  var imagePicker = UIImagePickerController()
                  imagePicker.delegate = self
                  imagePicker.sourceType = .camera;
                  imagePicker.allowsEditing = false
                  self.present(imagePicker, animated: true, completion: nil)
              }
          }))
          alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
              
              
              if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                  var imagePicker = UIImagePickerController()
                  imagePicker.delegate = self
                  imagePicker.sourceType = .photoLibrary;
                  imagePicker.allowsEditing = true
                  self.present(imagePicker, animated: true, completion: nil)
              }
              
          }))
          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
          self.present(alert, animated: true)
      }
      
      public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               self.selectedImage.isHidden =  false
               self.selectedImage.image = image
              self.removeImageBtn.isHidden =  false
              //self.AddPhotoBTN.isHidden =  true
              imageData = image.pngData()!
          }
          self.dismiss(animated: true, completion: nil)
      }
    @IBAction func removeImageBtn(_ sender: Any)
     {
         
         let alert = UIAlertController(title: "Delete Image", message: "Are You Sure You Want to Delete the Image form the Note?", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Delete", style: .destructive){
             UIAlertAction in
             self.selectedImage.isHidden = true
             self.removeImageBtn.isHidden = true
             self.imageData = Data()
         }
         alert.addAction(okAction)
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         alert.addAction(cancelAction)
         
         self.present(alert, animated: true, completion: nil)
     }
     
     func imagePickerControllerDidCancel(picker: UIImagePickerController) {
         self.dismiss(animated: true, completion: nil)
     }
}
