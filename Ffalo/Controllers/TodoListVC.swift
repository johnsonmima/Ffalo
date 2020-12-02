//
//  TodoListVC.swift
//  Ffalo
//
//  Created by Johnson Olusegun on 11/28/20.
//

import UIKit
import KRProgressHUD

class TodoListVC: UITableViewController {
    
    //let defaults = UserDefaults.standard
    
    // create a filemanager path
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemsArray:[ItemData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        KRProgressHUD.show()
        
        // load the item in the plist
        loadItems()
        
        // configure the navigation bar
        setupNavigationBar()
        // set up right and left bar button item
        setupNavigationRightButton()
        setupNavigationLeftButton()
        
        
       
        
        // retrive the data in user default
        
//        if let item = defaults.array(forKey: "TodoListDataArray") as? [ItemData] {
//
//            itemsArray = item
//        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    //MARK: - Setup navigation config
    
    
    func setupNavigationBar(){
        
        navigationController?.navigationBar.barTintColor = UIColor(named: K.DesignColors.generalColor)
        navigationController?.navigationBar.tintColor = UIColor(named: K.DesignColors.generalTextColor)
        
        
    }
    
    
    // set up right navigation title
    
    func setupNavigationLeftButton(){
        let appText = UIButton(type: .system)
        appText.setTitle("Ffola", for: .normal)
        appText.setTitleColor(UIColor(named: K.DesignColors.generalTextColor), for: .normal)
        
                
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: appText)
    }
    
    // set up navigation bar right button
    func setupNavigationRightButton(){
        
        //activity button
        let activityBtn = UIButton(type: .system)
        activityBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        activityBtn.setTitleColor(UIColor.red, for: .normal)
        
        // add btn
        let addBtn = UIButton(type: .system)
        addBtn.setImage(UIImage(systemName: "plus.square"), for: .normal)
        addBtn.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        let addBarButton = UIBarButtonItem(customView: addBtn)
        
        
        let activityBarButton = UIBarButtonItem(customView: activityBtn)
        
        navigationItem.rightBarButtonItems = [activityBarButton, addBarButton]
    }
    
    
    // MARK: - Table view data source

  
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TodoList.TodoItemCell, for: indexPath)
        cell.textLabel?.text = item.title
        
        // check if the table is seleceted or not
        
        cell.accessoryType = item.done == true ? .checkmark :  .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemsArray[indexPath.row])
        
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        // show loading
        DispatchQueue.main.async {
            KRProgressHUD.show()
        }
      saveItems()
        
//
//        if itemsArray[indexPath.row].checked == true {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        if tableView.cellForRow(at: indexPath)?.accessoryType ==  .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//
       
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @objc func addButtonPressed (){
        
        var itemField = UITextField()
        
        let alert = UIAlertController(title:"Add new Todo Item", message: "", preferredStyle: .alert)
        
      
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            itemField = alertTextField
        }
        
        
        // dismiss alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancel) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        // add new item
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            
            DispatchQueue.main.async {
                if let item = itemField.text {
                    self.itemsArray.append(Item(context:self.context))
                    
                    //self.defaults.setValue(self.itemsArray, forKey: "TodoListDataArray")
                    //self.defaults.set(self.itemsArray, forKey: "TodoListDataArray")
                    
                    KRProgressHUD.show()
                    self.saveItems()
                  
                }
                self.tableView.reloadData()
            }
           
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemsArray)
            try data.write(to: dataFilePath!)
            
            
            //
            
            DispatchQueue.main.async {
                KRProgressHUD.dismiss()
            }
        } catch let error as NSError {
           
            DispatchQueue.main.sync {
                KRProgressHUD.showError(withMessage: error.localizedDescription)
            }
        }
    
    }
    
    
    func loadItems(){
        
        let decoder = PropertyListDecoder()
        
        do {
            
            let data =  try Data(contentsOf: dataFilePath!)
            itemsArray = try decoder.decode([ItemData].self, from: data)
            
            // dismiss the progresss hub
            DispatchQueue.main.async {
                KRProgressHUD.dismiss()
            }
        } catch let error as NSError {
            KRProgressHUD.showError(withMessage: error.localizedDescription)
            //print(error)
        }
    }
    

}
