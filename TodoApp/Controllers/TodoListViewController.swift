//
//  ViewController.swift
//  TodoApp
//
//  Created by raihanalbazzy on 06/02/21.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray:[TodoItem] = []

    let userDefaults = UserDefaults.standard;
    let encoder = PropertyListEncoder()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        retrievedataFromLocal()
        // Do any additional setup after loading the view.
    }
    

    //MARK - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath);
        let todoItems = itemArray[indexPath.row]
        
        cell.textLabel?.text = todoItems.title
        cell.selectionStyle = .none
        cell.accessoryType = todoItems.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleTap(at: indexPath)
    }
    
    
    //MARK - function

    
    func handleTap(at indexPath:IndexPath) {
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveDataToLocal()
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showAlert();
    }
    
    func saveDataToLocal() {
        do {
            let data = try encoder.encode(self.itemArray);
            try data.write(to: dataFilePath!);
        } catch  {
            print("error encode")
        }
    }
    
    func retrievedataFromLocal() {
        if let retrieveData = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder();
            do {
                itemArray = try decoder.decode([TodoItem].self, from: retrieveData)
                
            } catch  {
                print("error parsing")
            }
        }
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
                let newItem = TodoItem(title: alertTextField.text!, done: false)
                self.itemArray.append(newItem)
                self.saveDataToLocal()
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


