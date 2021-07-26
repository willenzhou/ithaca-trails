//
//  Filter.swift
//  IthacaTrails2
//
//  Created by Justin Gu on 12/11/20.
//

import Foundation

class Filter{
    var filterName: String
    var filterOn: Bool
    
    init(name: String, filter: Bool) {
        filterName = name
        filterOn = filter
    }
    
    func setFilter(){
        filterOn.toggle()
    }
    
}
