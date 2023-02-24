//
//  BaseConfigurator.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 22/2/23.
//

import Foundation
import UIKit

@MainActor
class BaseConfigurator {
    
    var viewController: UIViewController {
        return createViewController()
    }
    
    private func createViewController() -> UIViewController {
        let view = MainConfigurator.createModule()
        return view
    }
    
    static func ConfigGlobalApareance(){
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            navigationBarAppearance.shadowColor = .clear
            navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }
    
    
}
