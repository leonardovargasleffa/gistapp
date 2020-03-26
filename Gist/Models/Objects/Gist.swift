//
//  Gist.swift
//  Gist
//
//  Created by Leonardo Leffa on 25/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper

class Gist: Mappable {

    var url: String!
    var forks_url: String!
    var commits_url: String!
    var id: String!
    var node_id: String!
    var git_pull_url: String!
    var git_push_url: String!
    var html_url: String!
    var is_public: Bool!
    var created_at: String!
    var updated_at: String!
    var description: String!
    var comments: Int!
    var user: User?
    var comments_url: String!
    var owner: User!
    var truncated: String!
    var files: Dictionary<String, Files>!
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        url <- map["url"]
        forks_url <- map["forks_url"]
        commits_url <- map["commits_url"]
        id <- map["id"]
        node_id <- map["node_id"]
        git_pull_url <- map["git_pull_url"]
        git_push_url <- map["git_push_url"]
        html_url <- map["html_url"]
        is_public <- map["public"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        description <- map["description"]
        comments <- map["comments"]
        user <- map["user"]
        comments_url <- map["comments_url"]
        owner <- map["owner"]
        truncated <- map["truncated"]
        files <- map["files"]
        
    }
    
}
