//
//  WebService.swift
//  Gist
//
//  Created by Leonardo Leffa on 25/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SwiftyJSON

enum Error: String, Swift.Error {
    case generic
    case unauthorized
    
    var code: Int {
        switch self {
            case .generic:
                return 201
            case .unauthorized:
                return 401
        }
    }
    
    var message: String {
        switch self {
            case .generic:
                return "Houve um erro. Tente novamente"
            case .unauthorized:
                return "Houve um erro. Faça o Login Novamente."
        }
    }
    
}

class WebService: NSObject {

    static let sharedInstance = WebService()
    let clientID = "7452db927cde7e102b37"
    let clientSecret = "cb2cab51908484699927454ef0f182292ae57361"
    
    var githubLogged:((String?) -> Void)!
    
    func OAuthURL() -> URL {
        let authPath:String = "https://github.com/login/oauth/authorize" +
            "?client_id=\(clientID)&scope=gist&state=gistoauthcallback"
        return URL(string: authPath)!
    }
    
    func getAccessToken(url: URL) -> String? {
        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        var code:String?
        guard let queryItems = components?.queryItems else {
            return nil
        }
        for queryItem in queryItems {
            if (queryItem.name.lowercased() == "code") {
                code = queryItem.value
                break
            }
        }
        return code
    }
    
    func loggedIn() -> Bool {
        if (UserDefaults.standard.value(forKey: "github_access_token") != nil) {
            return true;
        } else {
            return false;
        }
    }
    
    func getAuthHeader() -> String {
        return "Bearer \(UserDefaults.standard.value(forKey: "github_access_token")!)"
    }
    
    func getGitHubUserData() -> Observable<User> {
           
        return Observable<User>.create { observer -> Disposable in
            
            let headers: HTTPHeaders = [
                "Authorization": self.getAuthHeader()
            ]
            
            Alamofire.request("https://api.github.com/user", method: .get, parameters: [:], headers: headers)
                .responseObject(completionHandler: { (response: DataResponse<User>) in
                    
                    guard let user = response.result.value else {
                        observer.on(.error(Error.generic))
                        return
                    }
                    
                    observer.on(.next(user))
                    observer.on(.completed)
            })
            
            return Disposables.create()
        }
    }
    
    func commentGist(_ gist_id: String, _ comment: String) -> Observable<Comment> {
           
        return Observable<Comment>.create { observer -> Disposable in
            
            let headers: HTTPHeaders = [
                "Authorization": self.getAuthHeader()
            ]
            
         Alamofire.request("https://api.github.com/gists/\(gist_id)/comments", method: .post, parameters: ["body": comment], headers: headers).responseObject { (response: DataResponse<Comment>) in
                    
                    guard let gists = response.result.value else {
                        observer.on(.error(Error.generic))
                        return
                    }
                    
                    observer.on(.next(gists))
                    observer.on(.completed)
            }
            
            return Disposables.create()
        }
    }
    
    func getGistComments(_ gist_id: String, _ page: Int, _ perPage: Int) -> Observable<[Comment]> {
           
        return Observable<[Comment]>.create { observer -> Disposable in
            
            let headers: HTTPHeaders = [
                "Authorization": self.getAuthHeader()
            ]
            
         Alamofire.request("https://api.github.com/gists/\(gist_id)/comments?page=\(page)&perPage=\(perPage)", method: .get, parameters: [:], headers: headers).responseArray { (response: DataResponse<[Comment]>) in
                    
                    guard let gists = response.result.value else {
                        observer.on(.error(Error.generic))
                        return
                    }
                    
                    observer.on(.next(gists))
                    observer.on(.completed)
            }
            
            return Disposables.create()
        }
    }
    
    func getGist(_ gist_id: String) -> Observable<Gist> {
           
        return Observable<Gist>.create { observer -> Disposable in
            
            let headers: HTTPHeaders = [
                "Authorization": self.getAuthHeader()
            ]
            
         Alamofire.request("https://api.github.com/gists/\(gist_id)", method: .get, parameters: [:], headers: headers).responseObject { (response: DataResponse<Gist>) in
                    
                    guard let gists = response.result.value else {
                        observer.on(.error(Error.generic))
                        return
                    }
                    
                    observer.on(.next(gists))
                    observer.on(.completed)
            }
            
            return Disposables.create()
        }
    }
    
    func getGists(publicGists: Bool, _ page: Int, _ perPage: Int) -> Observable<Array<Gist>> {
              
           return Observable<Array<Gist>>.create { observer -> Disposable in
               
               let headers: HTTPHeaders = [
                   "Authorization": self.getAuthHeader()
               ]
               
            Alamofire.request("https://api.github.com/gists\(publicGists ? "/public" : "")?page=\(page)&perPage=\(perPage)", method: .get, parameters: [:], headers: headers).responseArray { (response: DataResponse<[Gist]>) in
                       
                       guard let gists = response.result.value else {
                           observer.on(.error(Error.generic))
                           return
                       }
                       
                       observer.on(.next(gists))
                       observer.on(.completed)
               }
               
               return Disposables.create()
           }
       }
    
    func processGistURL(url: URL){
        if let gistid = url.absoluteString.components(separatedBy: "gistopen://").dropFirst().first {
            NotificationCenter.default.post(name: Notification.Name("receiveGistID"), object: gistid, userInfo: [:])
        }
    }
    
    func processOAuthResponse(url: URL) {
        guard let code = getAccessToken(url: url) else {
            return;
        }
        
        let parameters = ["client_id": clientID, "client_secret": clientSecret, "code": code]
        
        Alamofire.request("https://github.com/login/oauth/access_token", method: .post, parameters: parameters)
            .responseString { response in
                if let json = response.result.value {
                    if let access_token: String = json.components(separatedBy: "&").first {
                        if let token = access_token.components(separatedBy: "=").dropFirst().first {
                            DispatchQueue.main.async {
                                UserDefaults.standard.setValue(token, forKey: "github_access_token")
                                self.githubLogged(nil);
                            }
                        } else {
                            self.githubLogged("Não foi possivel efetuar login!");
                        }
                        
                    } else {
                        self.githubLogged("Não conseguiu buscar o token!");
                    }
                    
                } else {
                    self.githubLogged("Erro na requisição!");
                }
        }
    }
    
}
