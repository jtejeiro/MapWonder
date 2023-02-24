//
//  MainViewModel.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 23/2/23.
//

import Foundation

struct MainViewModel {
    let listPois: [PoisAnnotation]
    
    static func mapToDomainModel(model:[PoisList]) -> MainViewModel {
        let listpois = model.map{ item in
        return PoisAnnotation(pois: item)
        }
        return MainViewModel(listPois: listpois)
    }
}
