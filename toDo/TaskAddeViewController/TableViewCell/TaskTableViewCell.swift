//
//  TaskTableViewCell.swift
//  toDo
//
//  Created by Ece Ok, Vodafone on 17.04.2024.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func taskConfigure(_ model : Task){
        taskLabel.text = model.textInfo
    }


    
}
