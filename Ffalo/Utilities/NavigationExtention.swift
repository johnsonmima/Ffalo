//
//  NavigationExtention.swift
//  Ffalo
//
//  Created by Johnson Olusegun on 12/12/20.
//

import Foundation
import UIKit
import ChameleonFramework

extension UIViewController{
    
    func configureNavigationBar(backgroundColor:UIColor, tintColor:UIColor, title:String, prefersLargeTitleText:Bool){
        
        
        
        
        if #available(iOS 13.0, *) {
          
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(backgroundColor, returnFlat: true) ]
            appearance.titleTextAttributes =  [NSAttributedString.Key.foregroundColor:ContrastColorOf(backgroundColor, returnFlat: true) ]
            appearance.backgroundColor = backgroundColor
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            
            navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitleText
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.title = title
            navigationController?.navigationBar.isTranslucent = false
            
            
            
        }
        else{
            navigationItem.title = title
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(backgroundColor, returnFlat: true)]
            navigationController?.navigationBar.barTintColor = backgroundColor
            navigationController?.navigationBar.tintColor = tintColor
            
            
        }
        
        
    }
    
    
    
    
}
