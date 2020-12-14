//
//  CategoryManager.swift
//  Ffalo
//
//  Created by Johnson Olusegun on 12/9/20.
//

import Foundation
import RealmSwift

//protocol
protocol DataManagerDelegate {
    // did fail with error
    func didFailWithError(_ error:NSError)
    
    // save
    func didSaveWithoutError(_ message:String)
    
    // reload data
    func didReloadData()
    
  
    
}



    
  



struct DataManager {
   
    // create realm instance
    let realm = try! Realm()
    
    // delegate mwthod
    var delegte:DataManagerDelegate? 
    
   // save method
    
    func saveCategory(category:Category){
        
        do {
            
            // save
            try realm.write{
                realm.add(category)
            }
            
            // called did save
            delegte?.didSaveWithoutError("Saved")
            // did reload
            delegte?.didReloadData()
            
        } catch let error as NSError {
            delegte?.didFailWithError(error)
            
        }
        
    }
    
    // load categories
    
    func loadCategories() -> Results<Category> {
        
      
    let results = realm.objects(Category.self)
       
        return results
        
    }
    
    // save items
    
    func saveNewItem(with item:Item, and selectedcategory:Category) {
        
        do {
            try realm.write {
                
                
                selectedcategory.items.append(item)
                realm.add(item)
            }
            // called did save
            delegte?.didSaveWithoutError("Saved")
            // did reload
            delegte?.didReloadData()
            
        } catch let error as NSError {
            delegte?.didFailWithError(error)
        }
    }
    
    
    
    // laod todo items
    
    func loadTodoItems(for selectedItem:Category) -> Results<Item>{
        
        let result = selectedItem.items.sorted(byKeyPath: "title", ascending: true)
      
        return result
    }
    
    
    // delete category model
    func deleteCategory(for category:Category){
        
        do {
            try realm.write{
                realm.delete(category)
                
            }
        } catch let error as NSError {
            delegte?.didFailWithError(error)
        }
        
        
    }
    
    // delete item
    
    func deleteItem(for item:Item){
        
        do {
            try realm.write{
                realm.delete(item)
                
            }
        } catch let error as NSError {
            delegte?.didFailWithError(error)
        }
        
        
    }
    
    // search bar method
    
    func searchItem(for name:String, in itemResult:Results<Item>) -> Results<Item> {
        
        let result = itemResult.filter("title CONTAINS[cd] %@", name)
        
        
        return result
    }
    
    
    // check and uncheck
    
    func isChecked(for item:Item){
        
        do {
            try realm.write{
                item.done = !item.done
            }
            delegte?.didReloadData()
            
        } catch let error as NSError {
            delegte?.didFailWithError(error)
        }
    }
    
}
