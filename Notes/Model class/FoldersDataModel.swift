//
//  Folders.swift
//  Notes
//  Copyright © 2020 Simranjot singh. All rights reserved.
//

import Foundation

import UIKit

class FoldersDataModel  {
    
 var folderName = String()
 var notesCount = Int()
    
init(folderName: String,notesCount: Int) {
      self.folderName  = folderName
      self.notesCount  = notesCount
  }
    init(){
        
    }

}
