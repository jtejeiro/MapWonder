//
//  RequestModel.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 22/2/23.
//

import Foundation

struct RequestModel  {
    let endpoint : Endpoints
    var queryItems : [String:String]?
    let httpMethod : HttpMethod = .GET
    var baseUrl : URLBase = .urlMap
    
    func getURL() -> String{
        return baseUrl.rawValue + endpoint.rawValue
    }
    
    enum HttpMethod : String{
        case GET
        case POST
    }

    enum Endpoints : String   {
        case pois = "/pois.json"
        case empty = ""
    }

    enum URLBase : String{
        case urlMap = "https://sergiocasero.es"

    }
}
