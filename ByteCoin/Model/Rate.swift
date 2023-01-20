//
//  Rate.swift
//  ByteCoin
//
//  Created by Arthur Obichkin on 21/01/23.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

struct Rate: Codable{
    let rate: Double;
    let asset_id_quote:String
    
    var rateAsString:String {
        return String(format: "%.02f", rate);
    }
}
