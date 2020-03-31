//
//  Comment.swift
//  Gist
//
//  Created by Leonardo Leffa on 30/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper
import Alamofire

class Comment: Mappable {

    var id: Int!
    var node_id: String!
    var url: String!
    var body: String!
    var user: User!
    var created_at: String!
    var updated_at: String!
 
    required init?(map: Map){}
    
    func mapping(map: Map) {
        id <- map["id"]
        node_id <- map["node_id"]
        url <- map["url"]
        body <- map["body"]
        user <- map["user"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
    
}
