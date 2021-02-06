//
//  ViewController.swift
//  TodoApp
//
//  Created by raihanalbazzy on 06/02/21.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"];
    let userDefaults = UserDefaults.standard;
    static let itemArrayKey = "RNmu5D89VWsKtZvmKkfgxfEaekcvBnWkRAhKHftG"
    
    var localStorage:[String]? {
        get {
            userDefaults.array(forKey: TodoListViewController.itemArrayKey) as? [String]
        }
        set {
            userDefaults.setValue(newValue, forKey: TodoListViewController.itemArrayKey);
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        reloadDataFromLocal()
        // Do any additional setup after loading the view.
    }
    

    //MARK - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath);
        cell.textLabel?.text = itemArray[indexPath.row];
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handleTap(at: indexPath);
    }
    
    
    //MARK - function
    
    func reloadDataFromLocal() {
        if localStorage != nil && localStorage!.count > 0 {
            itemArray = localStorage!
        }
    }
    
    func handleTap(at indexPath:IndexPath) {
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
      
    }
    //Mark - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showAlert();
    }
    
    func showAlert() {
        
        var alertTextField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Item", message: "Type what you gonna do today", preferredStyle: .alert);
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Create New Item"
            alertTextField = UITextField
        }
        
        
        let addAction = UIAlertAction(title: "Add item", style: .default) { (_) in
            if(!alertTextField.text!.isEmpty) {
                self.itemArray.append(alertTextField.text!)
                self.localStorage = self.itemArray
                self.tableView.reloadData()
            }
        }
        
        addAction.isEnabled = false
    
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alertTextField, queue: OperationQueue.main) { (notification) in
            addAction.isEnabled = (alertTextField.text?.trimmingCharacters(in: .whitespaces).count)! > 0
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        [cancelAction, addAction].forEach { (actions) -> Void in
            alert.addAction(actions)
        }

    
        present(alert, animated: true, completion: nil);
        
    }

}


