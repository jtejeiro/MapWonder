//
//  PoisAnnotation.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 22/2/23.
//

import UIKit
import MapKit

class PoisAnnotation: NSObject, MKAnnotation {
    let identifier:String?
    let title: String?
    let urlImg: String?
    let coordinate: CLLocationCoordinate2D

    init(identifier:String,
         title:String,
         urlImg: String,
         coordinate:CLLocationCoordinate2D)  {
        self.identifier = identifier
        self.title = title
        self.urlImg = urlImg
        self.coordinate = coordinate
    }
    
    init(pois: PoisList)  {
        self.identifier = pois.id
        self.title = pois.title
        self.urlImg = pois.image
        let location =  pois.geocoordinates.stringSeparatingCharactersWithString()
        let lat = location[0].toDouble() ?? 0.0
        let long = location[1].toDouble() ?? 0.0
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    

    
}
