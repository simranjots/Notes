//
//  ViewController.swift
//  Notes
//  Copyright © 2020 Simranjot singh. All rights reserved.
//
import Foundation
import UIKit
import CoreData


class FolderTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var folderName: UITextField!
    var note = 0
    let cellId = "cellId"
    
    var folders = FolderCoreData()
    var folderData = [FoldersDataModel]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isKeyPresentInUserDefaults(key: "hasCodeRun") == false
               {
                        folders.createFolderArray()
                        folders.createFolderData()
                   UserDefaults.standard.set(true, forKey: "hasCodeRun")
               }
        folders.retrieveFolderData()
        
        folderData = folders.dataArray
        
        // Do any additional setup after loading the view.
        tableView.register(FoldercellTableViewCell.self, forCellReuseIdentifier: cellId)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    
      
    }
     
     override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     // Dispose of any resources that can be recreated.
     }
     
    //swipe actions
   
 func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
    if folderData[indexPath.row].folderName == "Notes" {
        let action1 = UIContextualAction(
        style: .normal,
        title: "Can't Delete Folder",
        handler: { (action, view, completion) in
            completion(true)
                      })
                    
                      ///action1.image = UIImage(systemNAme:"trash")
        let configuration = UISwipeActionsConfiguration(actions: [action1])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    } else {
            let action1 = UIContextualAction(
                style: .normal,
                title: "Delete Folder",
                handler: { (action, view, completion) in
                    
                    let   appdelegate = UIApplication.shared.delegate as! AppDelegate;
                    
                    let context = appdelegate.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Folders")
                    fetchRequest.returnsObjectsAsFaults = false
                    
                    
   
                    do
                    {
                        let x = try context.fetch(fetchRequest)
                        let result = x as! [Folders]
                        print(result.count)
                        
                        print("deleting \(result[indexPath.row])")
                        context.delete(result[indexPath.row])
                        //print(zotes)
                        print(indexPath.row )
                        do
                        {
                            try context.save()
                        }
                        catch{
                            
                            print("error")
                        }
                        self.folderData.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        tableView.reloadData()
                        
                    }
                    catch
                    {
                        
                    }
                    
                    completion(true)
            })
            action1.backgroundColor = .red
            ///action1.image = UIImage(systemNAme:"trash")
            
            
            let configuration = UISwipeActionsConfiguration(actions: [action1])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
    }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let newVC = sb.instantiateViewController(identifier: "notesTable") as! NotesTableViewController
            
            navigationController?.pushViewController(newVC, animated: true)
        }
      

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return folderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! FoldercellTableViewCell
        
             let currentLastItem = folderData[indexPath.row]
        
        cell.folder.text = currentLastItem.folderName
        cell.notecount.text = String(currentLastItem.notesCount)
        return cell
    }

    
    @IBAction func NewFolderBtn(_ sender: Any) {
       displayNewFolderBox(message: "New Folder")
      
    }
        
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    
      
     func displayNewFolderBox(message:String){
          //create alert
          let alert = UIAlertController(title: message, message: "Enter a name for this folder", preferredStyle: .alert)
          
          //create cancel button
          let cancelAction = UIAlertAction(title: "Cancel" , style: .cancel)
          
          //create save button
          let saveAction = UIAlertAction(title: "Save", style: .default) { (action) -> Void in
             //validation logic goes here
            
              if((self.folderName.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!){
                  //if this code is run, that mean at least of the fields doesn't have value
                  self.folderName.text = ""
                
                self.displayNewFolderBox(message: "Folder name entered was invalid. Please enter name for the folder")
              }else if(self.folderName.text! == "Notes"){
                
                self.displayNewFolderBox(message: "This Folder Name Not allowed")
              }
              else{
                   let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   let context = appDelegate.persistentContainer.viewContext
                   
                   let folders = NSEntityDescription.insertNewObject(forEntityName: "Folders", into: context)
                       folders.setValue(self.folderName.text!, forKey: "folderName")
                       folders.setValue(self.note, forKey: "notesCount")
                       
                                              
                       do {
                           try context.save()
                           print(folders,"success")
                        self.folderData.append(FoldersDataModel(folderName: self.folderName.text!, notesCount: self.note))
                         self.tableView.reloadData()
                       } catch let error as NSError {
                           
                           print("Could not save. \(error), \(error.userInfo)")
                       }
                       
              print("This Folder was added : \(String(describing: self.folderName.text))")
               
          }
        
        }
          //add button to alert
          alert.addAction(cancelAction)
          alert.addAction(saveAction)
          
          //create first name textfield
          alert.addTextField(configurationHandler: {(textField: UITextField!) in
              textField.placeholder = "Name"
              self.folderName = textField
          })
          
          self.present(alert, animated: true, completion: nil)
      }
}


