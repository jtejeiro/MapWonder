//
//  MainConfigurator.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 22/2/23.
//

import UIKit
import Foundation

@MainActor
@objc final class MainConfigurator: NSObject {
    
    @objc class func createModule() -> UIViewController {
        
        let view = MainViewController()
        let presenter: MainPresenterImpl = MainPresenterImpl()
        let interactor = MainInteractorImpl()
        let router: MainRouterImpl =  MainRouterImpl(mainRouter: view)
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
}
