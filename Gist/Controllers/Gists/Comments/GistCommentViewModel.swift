//
//  GistCommentViewModel.swift
//  Gist
//
//  Created by Leonardo Leffa on 25/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit

class GistCommentViewModel: DefaultViewModel {
    
    var user: User!
    var listComments: [Comment] = []
    
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
    
    func clearComments(){
        self.listComments = []
        self.page = 1
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
    
    func setData(_ start: [Comment]){
        if(self.listComments.count > 0){
            self.listComments.append(contentsOf: start)
        } else {
            self.listComments = start
        }
        self.page += 1;
    }
    
    func getGistComment(_ gist: Gist, _ gists: @escaping ((_ gists: Bool) -> Void)){
        self.showLoading()
        WebService.sharedInstance.getGistComments(gist.id, self.page, self.perPage).subscribe(onNext: { [weak self] (start) in
            self!.stopLoading()
            self!.setData(start)
            gists(true)
        }, onError: { (error) in
            self.stopLoading()
            gists(false)
        }).disposed(by: self.disposeBag)
    }
    
    func commentGist(_ gist: Gist, _ comment: String, _ gists: @escaping ((_ gists: Comment?) -> Void)){
        self.showLoading()
        WebService.sharedInstance.commentGist(gist.id, comment).subscribe(onNext: { [weak self] (start) in
            self!.stopLoading()
            gists(start)
        }, onError: { (error) in
            self.stopLoading()
            gists(nil)
        }).disposed(by: self.disposeBag)
    }
}
