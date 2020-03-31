//
//  DefaultViewModel.swift
//  Gist
//
//  Created by Leonardo Leffa on 25/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class DefaultViewModel: NSObject {
    let disposeBag = DisposeBag()
    var logoutAction: (() -> Void)!
    var page: Int = 0
    var perPage: Int = 10
    var controller: UIViewController!
    
    init(_ controller: UIViewController, _ logoutAction:@escaping (() -> Void)) {
        super.init()
        self.controller = controller
        self.logoutAction = logoutAction
    }
    
    func showLoading(){
        MBProgressHUD.showAdded(to: self.controller.view, animated: true)
    }
    
    func stopLoading(){
        MBProgressHUD.hide(for: self.controller.view, animated: true)
    }
    
    func logoff(){
        UserDefaults.standard.removeObject(forKey: "github_access_token")
        self.logoutAction();
    }
}
