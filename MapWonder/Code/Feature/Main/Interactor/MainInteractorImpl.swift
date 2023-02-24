//
//  MainInteractorImpl.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 22/2/23.
//

import Foundation

class MainInteractorImpl {
    
    // MARK: - Properties
    weak var presenter: MainInteractorCallback?
    
    // MARK: - Repository
    
    // MARK: - Var
    
    init () {
    }
    
    func setPoisSessionManager(pois:PoisResponse){
        return PoisSessionManager.savePois(pois)
    }
}

extension MainInteractorImpl: MainInteractor {
    
    func fetchPoisApiClient() async throws -> PoisResponse {
        let requestModel = RequestModel(endpoint: .pois)
        do {
            
            if let poisSessionManager = getPoisSessionManager() {
               return poisSessionManager
            }
            
            let model = try await ServiceLayer.callService(requestModel,PoisResponse.self)
            debugPrint(model)
            setPoisSessionManager(pois: model)
            return model
        }catch{
            print(error)
            throw error
        }
    }
    
    func getPoisSessionManager() -> PoisResponse? {
        return PoisSessionManager.getPois() ?? nil
    }
    
    func removePoisSessionManager(){
        return PoisSessionManager.poisRemove()
    }
}
