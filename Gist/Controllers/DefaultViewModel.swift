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

class DefaultViewModel: NSObject {
    let disposeBag = DisposeBag()
    var logoutAction: (() -> Void)!
    
    init(_ controller: UIViewController, _ logoutAction:@escaping (() -> Void)) {
        super.init()
        self.logoutAction = logoutAction
    }
    
    func logoff(){
        UserDefaults.standard.removeObject(forKey: "github_access_token")
        self.logoutAction();
    }
}
