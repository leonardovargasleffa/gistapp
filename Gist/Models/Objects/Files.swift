//
//  Files.swift
//  Gist
//
//  Created by Leonardo Leffa on 25/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper
import Alamofire

class Files: Mappable {

    var filename: String!
    var type: String!
    var language: String!
    var raw_url: String!
    var content: String?
    var size: Int!
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        filename <- map["filename"]
        type <- map["type"]
        language <- map["language"]
        raw_url <- map["raw_url"]
        size <- map["size"]
        content <- map["content"]
    }
}
