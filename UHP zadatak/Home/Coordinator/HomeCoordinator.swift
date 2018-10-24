//
//  HomeCoordinator.swift
//  UHP zadatak
//
//  Created by Mateo Doslic on 24/10/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import UIKit
class HomeCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: HomeViewController
    init (presenter: UINavigationController){
        self.presenter = presenter
        let controller = HomeViewController()
        //Add ViewModel initialization.
        self.controller = controller
    }
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    
}

