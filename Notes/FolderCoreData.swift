//
//  NotesCoreData.swift
//  Notes
//  Copyright © 2020 Simranjot singh. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class FolderCoreData: NSObject {
    
    var d = [FoldersDataModel]()
    var dataArray = [FoldersDataModel]()
    
    
    var folder = [(folderName: "Notes", notesCount: 0)]
    
    
    
    func createFolderArray()
    {
        
        for i in folder
        {
            let data = FoldersDataModel()
            data.folderName = i.folderName
            data.notesCount = i.notesCount
            
            d.append(data)
            print(data.folderName, "create array")
        
        }
        
    }
    
    
    public func createFolderData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
       
        for i in d{
         let folders = NSEntityDescription.insertNewObject(forEntityName: "Folders", into: context)
        folders.setValue(i.folderName, forKey: "folderName")
        folders.setValue(i.notesCount, forKey: "notesCount")
        
        
            //print(n.color)
        
        do {
            try context.save()
            print(folders,"success")
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    }

    func retrieveFolderData() {
        
        // As we know that container is set up in the AppDelegates so we need to refer that container.
        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
        
        //We need to create a context from this container.
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        //prepare the request of type NSFetchRequest for the entity
        let fetchUser = NSFetchRequest<NSFetchRequestResult>(entityName: "Folders")
        
        
        
        if let result = try? managedContext?.fetch(fetchUser){
                for object in result as! [NSManagedObject] {
                    let folderName = object.value(forKey: "folderName") as! String
                    let notesCount = object.value(forKey: "notesCount") as! Int
                    
                    
                    let data = FoldersDataModel()
                    
                    data.folderName = folderName
                    data.notesCount = notesCount
                    print(data)
                    
                    
                    dataArray.append(data)
                }
                
            
            
        }
        
        
    }
    

    
    
}
