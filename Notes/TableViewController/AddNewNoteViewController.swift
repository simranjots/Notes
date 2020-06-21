//
//  AddNewNoteViewController.swift
//  Notes
//
//  Created by Richa Patel on 2020-06-11.
//  Copyright © 2020 Simranjot singh. All rights reserved.
//
import FittedSheets
import UIKit
import FloatingButtonPOP_swift
import CoreData
import MapKit
import CoreLocation
import Photos
import AVFoundation
import MediaPlayer


class AddNewNoteViewController: UIViewController,FloaterViewDelegate, CLLocationManagerDelegate, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UNUserNotificationCenterDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate   {
      
    
    @IBOutlet weak var labeltitle: UITextField!
    
    @IBOutlet weak var descText: UITextView!

    
    var category = ""
    var noteArray = [NotesDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//          labeltitle.text = "Enter Title"
//          labeltitle.textColor = UIColor.lightGray
//
//         descText.delegate = self
//         descText.text = ""
//         descText.textColor = UIColor.lightGray
        
        // Do any additional setup after loading the view.

         addFloaterMenu(with: [("Camera", UIImage(named: "camera")),("microphone", UIImage(named: "microphone")),("trash", UIImage(named: "trash"))], mainItem: ("", UIImage(named: "plus")), dropShadow: true)
         
        
    }
    

    
    func userDidTapOnItem(at index: Int, with model: String) {
        if index == 1 {
             let sb = UIStoryboard(name: "Main", bundle: nil)
              let newVC = sb.instantiateViewController(identifier: "image") as! ImageViewController

             navigationController?.pushViewController(newVC, animated: false)
        }
        if (index == 2){
      let controller = AddNewNoteViewController()

     let sheetController = SheetViewController(controller: controller, sizes: [.fixed(100), .fixed(200), .halfScreen, .fullScreen])

        // Adjust how the bottom safe area is handled on iPhone X screens
        sheetController.blurBottomSafeArea = true
        sheetController.adjustForBottomSafeArea = true

        // Turn off rounded corners
        sheetController.topCornersRadius = 0

        // Make corners more round
        sheetController.topCornersRadius = 15

        // Disable the dismiss on background tap functionality
        sheetController.dismissOnBackgroundTap = true

        // Extend the background behind the pull bar instead of having it transparent
        sheetController.extendBackgroundBehindHandle = true

        self.present(sheetController, animated: false, completion: nil)
        }
        
        
        
        }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func saveBtn(_ sender: Any) {
        
        let desc = descText.text
        let note = NotesDataModel()
        let title = labeltitle.text
        let date = Date()
        note.title = title!
        note.createdAt = date
        note.desc = desc!
        note.category = self.category

        
        noteArray.append(note)
        print(self.category)
        saveToCoreData()
    navigationController?.popViewController(animated: true)

    }
    
    
    
    
    
       //save to core data
       func saveToCoreData()
       {
           //deleteData()
           
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let context = appDelegate.persistentContainer.viewContext
           let newTask = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context)
           for i in noteArray
           {
               newTask.setValue(i.title, forKey: "title")
               //newTask.setValue(Int16(i.noOfDays), forKey: "noOfDays")
               newTask.setValue(i.desc, forKey: "desc")
               newTask.setValue(i.category, forKey: "category")
               //newTask.setValue(i.createdAt, forKey: "date")
               //newTask.setValue(i.lat, forKey: "latitude")
               //newTask.setValue(i.long, forKey: "longitude")
               //newTask.setValue(i.imageData, forKey: "image")
               //newTask.setValue(i.audiopath, forKey: "audiopath")
               
               
               
               do
               {
                   try context.save()
                   print(newTask, "is saved")
               }catch
               {
                   print(error)
               }
           }
           
       }
      

}
