//
//  FoldercellTableViewCell.swift
//  Notes
//  Copyright © 2020 Simranjot singh. All rights reserved.
//

import UIKit

class FoldercellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var folder: UILabel!
    
    @IBOutlet weak var folderImage: UIImageView!
    
    @IBOutlet weak var notecount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
