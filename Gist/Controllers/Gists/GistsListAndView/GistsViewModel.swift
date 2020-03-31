//
//  GistsViewModel.swift
//  Gist
//
//  Created by Leonardo Leffa on 25/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit

class GistsViewModel: DefaultViewModel {
    
    var user: User!
    var listGists: [Gist] = []
    
    init(_ controller: UIViewController) {
        super.init(controller, {
            if let nav = controller.navigationController {
                nav.dismiss(animated: true, completion: nil)
            }
        })
        
        self.getUser { (usr) in
            if(usr == nil){
                self.logoff()
            } else {
                self.user = usr;
            }
        }
    }
    
    func clearGists(){
        self.listGists = []
        self.page = 1
    }
    
    func getGists(_ publicGists: Bool, _ callback: @escaping ((_ gists: Bool) -> Void)){
        if(publicGists){
            self.getPublicGists { (gists) in
                callback(gists)
            }
        } else {
            self.getMyGists { (gists) in
                callback(gists)
            }
        }
    }
    
    func getUser(_ user: @escaping ((_ usr: User?) -> Void)) {
        self.showLoading()
        WebService.sharedInstance.getGitHubUserData().subscribe(onNext: { [weak self] (start) in
            self!.stopLoading()
            user(start)
        }, onError: { (error) in
            self.stopLoading()
            user(nil)
        }).disposed(by: self.disposeBag)
    }
    
    func setData(_ start: [Gist]){
        if(self.listGists.count > 0){
            self.listGists.append(contentsOf: start)
        } else {
            self.listGists = start
        }
        self.page += 1;
    }
    
    func getPublicGists(_ gists: @escaping ((_ gists: Bool) -> Void)){
        self.showLoading()
        WebService.sharedInstance.getGists(publicGists: true, self.page, self.perPage).subscribe(onNext: { [weak self] (start) in
            self?.stopLoading()
            self!.setData(start)
            gists(true)
        }, onError: { (error) in
            self.stopLoading()
            gists(false)
        }).disposed(by: self.disposeBag)
    }
    
    func getMyGists(_ gists: @escaping ((_ gists: Bool) -> Void)){
        self.showLoading()
        WebService.sharedInstance.getGists(publicGists: false, self.page, self.perPage).subscribe(onNext: { [weak self] (start) in
            self!.stopLoading()
            self!.setData(start)
            gists(true)
        }, onError: { (error) in
            self.stopLoading()
            gists(false)
        }).disposed(by: self.disposeBag)
    }
    
    func getGist(_ gist: String, _ gists: @escaping ((_ gists: Gist?) -> Void)){
        self.showLoading()
        WebService.sharedInstance.getGist(gist).subscribe(onNext: { [weak self] (start) in
            self!.stopLoading()
            gists(start)
        }, onError: { (error) in
            self.stopLoading()
            gists(nil)
        }).disposed(by: self.disposeBag)
    }
    
}
