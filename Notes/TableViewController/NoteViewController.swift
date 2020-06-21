//
//  NoteViewController.swift
//  Notes
//  Copyright © 2020 Simranjot singh. All rights reserved.
//


import UIKit
import FloatingButtonPOP_swift
import CoreData



class NoteViewController: UIViewController,FloaterViewDelegate, UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    
    @IBOutlet var labelTitle: UITextField!
    
    @IBOutlet weak var labelDesc: UITextView!
    
      //pre required data from notesTableviewCOntroller
    var note = NotesDataModel()
    var notesArray : [NotesDataModel] = []
    var categoryPassed = ""
    //var imageData = Data()
    var count = Int()


    func userDidTapOnItem(at index: Int, with model: String) {
                   print(model)
                   print(index)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        //back functionality
        count = 0
        
   
        
        //displaying data
        labelTitle.text = note.title
        labelDesc.text = note.desc
        
        
        
       addFloaterMenu(with: [("Camera", UIImage(named: "camera")),("microphone", UIImage(named: "microphone")),("trash", UIImage(named: "trash"))], mainItem: ("", UIImage(named: "plus")), dropShadow: true)
     
        
        
        

         //setting large titles
         navigationController?.navigationItem.largeTitleDisplayMode = .never
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        notesArray.removeAll()
        loadFromCoreData()
             labelTitle.text = note.title
             labelDesc.text = note.desc
         print(notesArray.count)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        print(categoryPassed)
               if count == 0{
                   let title = labelTitle.text
                   let desc = labelDesc.text
                   let date = note.createdAt
                   let image = note.imageData
                   let category = note.category
                   let lat = note.lat
                   let long = note.long
                   let note1 = NotesDataModel()
                   note1.title = title!
                   note1.desc = desc!
                   note1.createdAt = date
//                   if imageTask.isHidden
//                   {
//                       note1.imageData.removeAll()
//                   }else{
//                       note1.imageData = note.imageData
//                   }
//                   let filemanager = FileManager.default
//                   if filemanager.fileExists(atPath:getFileUrl().path)
//                   {
//
//                       do{
//                           let path = getDocumentsDirectory()
//                           let originPath = path.appendingPathComponent(note.title+note.desc)
//                           print(originPath)
//                           let destinationPath = path.appendingPathComponent(title!+desc!)
//                           print(destinationPath)
//                           try FileManager.default.moveItem(at: originPath, to: destinationPath)
//                       } catch {
//                           print(error)
//                       }
//
//                   }
//                   if audioPlayerView.isHidden
//                   {
//                       note1.audiopath = ""
//                   }else
//                   {
//                       note1.audiopath = note.audiopath
//                   }
//                   print(note1.audiopath)
                  note1.category = categoryPassed
                   note1.lat = lat
                   note1.long = long
                   deleteData()
                   //note.category = category
                   print(category)
                   print(note1.category)
                   notesArray.removeAll()
                   loadFromCoreData()
                   notesArray.append(note1)
                   saveToCoreData()
               }
               
        
    }
    
    @IBAction func saveBtn(_ sender: Any) {
           
        navigationController?.popViewController(animated: true)
    }
    
    
     
     
     
     
     func saveToCoreData()
     {
         //deleteData()
         
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let context = appDelegate.persistentContainer.viewContext
         let newTask = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context)
         for i in notesArray
         {
             newTask.setValue(i.title, forKey: "title")
             //newTask.setValue(Int16(i.noOfDays), forKey: "noOfDays")
             newTask.setValue(i.desc, forKey: "desc")
             newTask.setValue(i.category, forKey: "category")
             newTask.setValue(i.createdAt, forKey: "date")
             newTask.setValue(i.lat, forKey: "latitude")
             newTask.setValue(i.long, forKey: "longitude")
             newTask.setValue(i.imageData, forKey: "image")
             newTask.setValue(i.audiopath, forKey: "audiopath")
             
             
             
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
     
     func clearCoreData ()
     {
         
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         
         let context = appDelegate.persistentContainer.viewContext
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
         fetchRequest.returnsObjectsAsFaults = false
         do{
             let results = try context.fetch(fetchRequest)
             
             for managedObjects in results{
                 if let managedObjectsData = managedObjects as? NSManagedObject
                 {
                     context.delete(managedObjectsData)
                 }
                 
             }
         }catch{
             print(error)
         }
         
     }
     func loadFromCoreData()
     {
         
         // self.clearCoreData()
         
         
         // new
         
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         
         let context = appDelegate.persistentContainer.viewContext
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
         fetchRequest.returnsObjectsAsFaults = false
         
         
         
         if let result = try? context.fetch(fetchRequest) {
             for object in result as! [NSManagedObject] {
                 
                 
                 let title = object.value(forKey: "title")
                 let desc = object.value(forKey: "desc")
                 let lat = object.value(forKey: "latitude")
                 let long = object.value(forKey: "longitude")
                 let image = object.value(forKey: "image")
                 let category = object.value(forKey: "category")
                 let audiopath = object.value(forKey: "audiopath")
                 
                 
                 
                 let note = NotesDataModel()
                 note.title = title as! String
                 note.desc = desc as! String
                 note.lat = lat as! Double
                 note.long = long as! Double
                 if (image != nil)
                 {
                     note.imageData  = image as! Data
                 }
                 if (audiopath != nil)
                 {
                     note.audiopath = audiopath as! String
                 }
                 
                 note.category = category as! String
                 
                 
                 
                 notesArray.append(note)
             }
         }
         
     }
     func deleteData()
     {
         
         // create an instance of app delegate
         
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         
         let context = appDelegate.persistentContainer.viewContext
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
         
         fetchRequest.returnsObjectsAsFaults = false
         
         
         let predicate = NSPredicate(format: "title=%@", "\(note.title)")
         fetchRequest.predicate = predicate
         if let result = try? context.fetch(fetchRequest) {
             for object in result {
                 context.delete(object as! NSManagedObject)
             }
         }
         
         
         do
         {
             try context.save()
         }
         catch{
             
             print("error")
         }
         
     }
     
}
