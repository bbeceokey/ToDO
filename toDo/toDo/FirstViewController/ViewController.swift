//
//  ViewController.swift
//  toDo
//
//  Created by Ece Ok, Vodafone on 16.04.2024.
//

import UIKit
import FirebaseDatabaseInternal

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  ,TaskAddedViewControllerDelegate {
    
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var progressBtn: UIButton!
    @IBOutlet weak var todoBtn: UIButton!
    @IBOutlet weak var addTaskBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    var activeButton: UIButton?
    var allTasks = [Task]()
    var filteredTasks: [Task] = []
    var filtertasks = [Task]()
    let ref = Database.database().reference()
    func taskAddedViewControllerDidFinish(_ controller: TaskAddedViewController) {
        controller.dismiss(animated: true, completion: nil)
        getSnapshot()
        
    }

    func getSnapshot() {
            let newRef = Database.database().reference().child("Tasks")
                newRef.observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self else { return }
                    for children in snapshot.children {

                        let key = (children as AnyObject).key as String
                        self.getData(key)
                        print("***** key: \(key)")
                    }
            }
        }

        func getData(_ key: String) {
            allTasks.removeAll()
            let newRef = ref.child("Tasks").child(key)
            newRef.observeSingleEvent(of: .value, with: { [weak self] snapshot in
                guard let self = self else { return }

                let dictionary = snapshot.value as? [String: Any] ?? [:]
                let name = dictionary["textInfo"] as? String ?? "Unknown"
                let status = dictionary["status"] as? String ?? "To Do"
                let task = Task(textInfo: name, status: status)
                allTasks.append(task)
    
            })
        }


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.setTitle("Done", for: .normal)
        progressBtn.setTitle("In Progress", for: .normal)
        todoBtn.setTitle("To Do", for: .normal)
        getSnapshot()
       
    }
    
    
    @IBAction func filterTasks(_ sender: UIButton) {
        if let previousButton = activeButton {
               previousButton.isEnabled = true
           }
           sender.isEnabled = false
           activeButton = sender
           getSnapshot()
        for task in allTasks {
            if let status = task.status as? String, let buttonTitle = sender.titleLabel?.text, status == buttonTitle {
                filteredTasks.append(task)
            }
        }

        var tableView = updateTableView(with: filteredTasks) // updateTableView'ı uygun şekilde çağırın
        filtertasks = filteredTasks
        tableView.reloadData()
        mainView.addSubview(tableView)
        filteredTasks.removeAll()
    }
    
    @IBAction func addedTask(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TaskAddedViewController") as! TaskAddedViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func updateTableView(with tasks: [Task]) -> UITableView {
        // Önce mevcut tabloyu bulalım
        
        var tableView: UITableView!
        for subview in mainView.subviews {
            if let subTableView = subview as? UITableView {
                tableView = subTableView
                break
            }
        }
        
        
        if tableView == nil {
            tableView = UITableView(frame: mainView.bounds, style: .plain)
            tableView.delegate = self
            tableView.dataSource = self
            
                tableView.layer.borderWidth = 2.0
                tableView.layer.borderColor = UIColor.black.cgColor
            tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "tableCell")
            
        }
        return tableView

        // Tabloyu güncelle
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TaskTableViewCell
       
        let task = filtertasks[indexPath.row]
        cell.taskConfigure(task)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtertasks.count
       }



}

