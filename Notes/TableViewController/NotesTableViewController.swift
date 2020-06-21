//
//  NotesTableViewController.swift
//  Notes
//  Copyright © 2020 Simranjot singh. All rights reserved.
//

import UIKit
import CoreData


class NotesTableViewController: UITableViewController {
   
      var category : String = ""
       var notesArray = [NotesDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello")
         print(category)
        loadFromCoreData()

      

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
       
    }

    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {
        notesArray.removeAll()
        loadFromCoreData()
        print(notesArray.count)
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notesArray.count
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         let sb = UIStoryboard(name: "Main", bundle: nil)
         let newVC = sb.instantiateViewController(identifier: "notesView") as! NoteViewController
        var currnote = NotesDataModel()
        newVC.note = currnote
        newVC.categoryPassed = self.category
        print(currnote.category)
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as! NotesTableViewCell
        
        

            let currnote =  notesArray[indexPath.row]

        cell.title.text = currnote.title
        cell.descLabel.text = currnote.desc
        cell.date.text = currnote.dateString
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 6
        return cell
    }
    
    
    
    
    //swipe actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        

        let action1 = UIContextualAction(
            style: .normal,
            title: "Delete Note",
            handler: { (action, view, completion) in
                
                let   appdelegate = UIApplication.shared.delegate as! AppDelegate;
                
                let context = appdelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Notes")
                fetchRequest.returnsObjectsAsFaults = false
                
                
                let predicate = NSPredicate(format: "category=%@", "\(self.category)")
                fetchRequest.predicate = predicate
                
                do
                {
                    let x = try context.fetch(fetchRequest)
                    let result = x as! [Notes]
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
                    self.notesArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                    
                }
                catch
                {
                    
                }
                
                completion(true)
        })
        action1.backgroundColor = .red
        action1.image = UIImage(systemName: "trash")
        
        
        let configuration = UISwipeActionsConfiguration(actions: [action1])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
    
    @IBAction func AddNewNote(_ sender: Any) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let newVC = sb.instantiateViewController(identifier: "addNotes") as! AddNewNoteViewController
        
    navigationController?.pushViewController(newVC, animated: true)
    }
    
    
      
      //coredata functions
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
          
          
          let predicate = NSPredicate(format: "category=%@", "\(category)")
          fetchRequest.predicate = predicate
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
                  note.category = category as! String
                  if (image != nil)
                  {
                      note.imageData  = image as! Data
                  }
                  if (audiopath != nil)
                  {
                      note.audiopath = audiopath as! String
                  }
                  
                  
                  notesArray.append(note)
              }
          }
          
      }
      

}
class NotesTableViewCell: UITableViewCell {
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension UIView {
    
    func setCardView(){
        layer.cornerRadius = 5.0
        layer.borderColor  =  UIColor.clear.cgColor
        layer.borderWidth = 5.0
        layer.shadowOpacity = 0.5
        layer.shadowColor =  UIColor.lightGray.cgColor
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width:5, height: 5)
        layer.masksToBounds = true
    }
    func addShadow(){
        self.layer.cornerRadius = 30.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 12.0
        self.layer.shadowOpacity = 0.7
        
    }
}
