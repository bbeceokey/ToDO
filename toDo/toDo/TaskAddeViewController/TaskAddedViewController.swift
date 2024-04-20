//
//  TaskAddedViewController.swift
//  toDo
//
//  Created by Ece Ok, Vodafone on 17.04.2024.
//

import UIKit
import FirebaseDatabaseInternal

protocol TaskAddedViewControllerDelegate: AnyObject {
    func taskAddedViewControllerDidFinish(_ controller: TaskAddedViewController)
}

class TaskAddedViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    weak var delegate: TaskAddedViewControllerDelegate?


    @IBOutlet weak var taskInfo: UITextView!
    @IBOutlet weak var taskStatus: UIPickerView!
    let statuses = ["To Do", "Done", "In Progress"]
    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        taskStatus.dataSource = self
        taskStatus.delegate = self

    }
    func addTaskToFirebase(task: Task) {
        let taskData: [String: Any] = ["textInfo": task.textInfo, "status": task.status]
        
        ref.child("Tasks").childByAutoId().setValue(taskData) { (error, ref) in
            if let error = error {
                print("Error adding task: \(error.localizedDescription)")
            } else {
                print("Task added successfully!")
                // Gönderildikten sonra UI veya başka bir işlem yapılabilir
            }
        }
    }

    @IBAction func addTask(_ sender: Any) {
        let selectedStatus = statuses[taskStatus.selectedRow(inComponent: 0)]
            let taskTextInfo = taskInfo.text ?? ""
            
            let task = Task(textInfo: taskTextInfo, status: selectedStatus)
       addTaskToFirebase(task: task)
        taskInfo.text = ""
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return statuses.count
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return statuses[row]
       }
   
    
}
