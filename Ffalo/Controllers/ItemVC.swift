//
//  ItemVC.swift
//  Ffalo
//
//  Created by Johnson Olusegun on 12/10/20.
//

import UIKit
import RealmSwift
import KRProgressHUD
import ChameleonFramework

class ItemVC: SwipeTableViewController {

    

    @IBOutlet weak var searchBar: UISearchBar!
    
    var dataManager = DataManager()
    
    var itemResult:Results<Item>?
    
    // selected category var
    var selectedCategory:Category? {
        didSet{
            
            guard let sCat = selectedCategory  else { return }
            itemResult =  dataManager.loadTodoItems(for: sCat)
            
            
        }
    }
    
    // realm instance
    //let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the search bar delegate
        searchBar.delegate = self
        
        // set the delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // set the delegte
        dataManager.delegte = self
        // reload data
        tableView.reloadData()
        
    }
    
    //MARK:-  view willapear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let categoryColor = selectedCategory?.color {
            if let catUIColor = UIColor(hexString: categoryColor) {
                configureNavigationBar(backgroundColor: catUIColor, tintColor: ContrastColorOf(catUIColor, returnFlat: true), title: selectedCategory?.name ?? "", prefersLargeTitleText: true)
                // set the search bar tint color
                searchBar.barTintColor = catUIColor
                searchBar.tintColor = ContrastColorOf(catUIColor, returnFlat: true)
                
            }
            
            
        }
        
       
    }
    

    //MARK:- ADD BUTTON ACTION PRESSED
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        
        
        // new item textfield
        let itemName = UITextField()
        
    // create a new item
        
        let alertController = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)
    
        
        // cancel action
        
        let cancelActionBtn = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        // add action
        let addActonBtn = UIAlertAction(title: "Add", style: .default) { (_) in
            // unwrapp selected Category
            guard let selectedCat = self.selectedCategory else { return }
            
            
            
            // create new item
            if let newItemText = itemName.text {
                
                // create new Item
                   let newItem = Item()
                   newItem.title = newItemText
                
                self.dataManager.saveNewItem(with: newItem, and: selectedCat)
                
            }
            
            
        }
        
        // add text input
        alertController.addTextField { (addTextField) in
            // set default design
            addTextField.placeholder = "Name is required"
            addTextField.borderStyle = .roundedRect
            addTextField.clearButtonMode = .whileEditing
            
            
            // enable or disable the add button based on textDidChangeNotification
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: addTextField, queue: OperationQueue.main) { (_) in
                
                if let newText = addTextField.text {
                    
                 // check if the char > 0
                    if newText.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
                        // update itemName
                        itemName.text = newText
                        // enable the add button
                        addActonBtn.isEnabled = true
                    }
                    else{
                        addActonBtn.isEnabled = false
                    }
                    
                }
                
                
                
                
            }
            
            
        }
        
        
        // set actions
        alertController.addAction(cancelActionBtn)
        
        // disable add action
        addActonBtn.isEnabled = false
        alertController.addAction(addActonBtn)
        
        // present alert controller
        present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK:- Table DataSource, and Delegate Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResult?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
       
        
        if let item = itemResult?[indexPath.row] {
            
            // color percentage
            let percentage = CGFloat(indexPath.row) / CGFloat(itemResult?.count ?? 1)
           
            // set the cell color
            if let selectedCatColor = selectedCategory?.color {
                
                if let selectedCatColorUIColor = UIColor(hexString: selectedCatColor){
                    
                    // genrated color
                    if  let generatedSelectedCatColorUIColor = selectedCatColorUIColor.darken(byPercentage: percentage) {
                      
                        cell.backgroundColor = generatedSelectedCatColorUIColor
                        
                        cell.textLabel?.textColor = ContrastColorOf(generatedSelectedCatColorUIColor, returnFlat: true)
                        cell.textLabel?.text = item.title
                        
                        // set cell tint color
                        cell.tintColor = ContrastColorOf(generatedSelectedCatColorUIColor, returnFlat: true)
                        cell.accessoryType = item.done ? .checkmark : .none
                    }
                    
                }
                
                
            }
           

            
            
            
            
        }
        else{
            cell.textLabel?.text = "No Item"
        }
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // untap check and uncheck
        
        guard let currentItem = itemResult?[indexPath.row] else { return }
        // check item
        dataManager.isChecked(for: currentItem)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    // delete method
    
    override func updateModel(for index: IndexPath) {
        
        if let selectedItem = itemResult?[index.row] {
            dataManager.deleteItem(for: selectedItem)
        }
       
    }

    
}

//MARK:- Search Bar MEthods

extension ItemVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        performSearch(with: searchText)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(with: searchText)
       
    }
    
    
    // search helper method
    func performSearch(with searchText:String){
        
        // check if text > o
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            
            guard let selectedCat = self.selectedCategory else { return }
            
            itemResult = dataManager.loadTodoItems(for: selectedCat)
            
            
            // resign keyboard
            searchBar.resignFirstResponder()
            //reload data
            tableView.reloadData()
        }
        else {
            
            guard let curentResult = itemResult else { return }
            itemResult =  dataManager.searchItem(for: searchText, in: curentResult)
            //reload data
            tableView.reloadData()
        }
    }
    
    
}






extension ItemVC: DataManagerDelegate {

    
    func didFailWithError(_ error: NSError) {
        
        KRProgressHUD.showError(withMessage: "Unable to save try again")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            KRProgressHUD.dismiss()
        }
        
    }
    
    func didSaveWithoutError(_ message: String) {
        
        KRProgressHUD.showSuccess(withMessage: "Saved")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            KRProgressHUD.dismiss()
        }
    }
    
    func didReloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
   
}
