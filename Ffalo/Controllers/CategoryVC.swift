//
//  CategoryVC.swift
//  Ffalo
//
//  Created by Johnson Olusegun on 12/9/20.
//

import UIKit
import KRProgressHUD
import RealmSwift
import ChameleonFramework

class CategoryVC: SwipeTableViewController {

    // result array
    var categories:Results<Category>?
    
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        dataManager.delegte = self
        
        // laod categories
        categories =  dataManager.loadCategories()
        
    tableView.reloadData()

    }
    
    //MARK:-
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK:- Set up navigation appearance
        // nav bar set up
       configureNavigationBar(backgroundColor: UIColor(named: K.DesignColors.BG_PRIMARY_COLOR)!, tintColor: UIColor(named: K.DesignColors.PRIMARY_TEXT_COLOR)!, title: "Ffalo", prefersLargeTitleText: true)
        
    }
    
    
   
    

    
    
    //MARK:- Add Button Pressed
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
    // text field variable
    let categoryName = UITextField()
        
    // create alert controller
        
        let alertController = UIAlertController(title: "Create Category", message: "", preferredStyle: .alert)
        
        
        // create cancel action
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        
        // create add action
        
        let addBtn = UIAlertAction(title: "Create", style: .default) { (_) in
            
            // create new category
            
            // get category color
            let categoryColor = RandomFlatColor().hexValue()
            
            let newcategory = Category()
            
            // unwrap the text field
            if let text = categoryName.text {
                newcategory.name = text
                newcategory.color = categoryColor
            }
            
            // call save method
            self.dataManager.saveCategory(category: newcategory)
           
            
            
        }
        
        // add text field
        alertController.addTextField { (catTextField) in
            // text field set up
            catTextField.placeholder = "Enter Category name"
            catTextField.clearButtonMode = .whileEditing
            catTextField.borderStyle = .roundedRect
            
            // listen for textDidChangeNotification change
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: catTextField, queue: OperationQueue.main) { (_) in
                
                // safely unwrapp the value
                if let text = catTextField.text {
                   
                   // check if the text is > 0
                    
                    if text.count > 0 {
                        categoryName.text = text
                        addBtn.isEnabled = true
                    }
                    else{
                        addBtn.isEnabled = false
                    }
                    
                }
                
                
                
            }
            
            
        }
        
       
        
        // diable the add button
        addBtn.isEnabled = false
        
        // add the cancel and add action
        alertController.addAction(cancel)
        alertController.addAction(addBtn)
        
    // present the action
       present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    //MARK:- Table Delegate, DataSource and Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // check if count > 0
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Empty category"
        
        if let catColor = categories?[indexPath.row].color {
        
            if let catUIColor = UIColor(hexString: catColor) {
                
                // set bg color
                cell.backgroundColor = catUIColor
                // set bg text
                    cell.textLabel?.textColor = ContrastColorOf(catUIColor, returnFlat: true)
            }
            
        
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // navegate to item VC
        
        performSegue(withIdentifier: K.SegueIdentifiers.TO_ITEMS_VC, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // prepare for segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemVC
        
        
        // send the selected object
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexpath.row]
        }
    }
    
    
    // overide the super update method
    override func updateModel(for index: IndexPath) {
        
        guard let currentCategory = categories?[index.row] else { return }
        dataManager.deleteCategory(for: currentCategory)
        
    }
    
    
    
    
}

//MARK:- Category Manager Delegate

extension CategoryVC:DataManagerDelegate {
   

    
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
