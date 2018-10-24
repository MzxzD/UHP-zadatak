//
//  AppCoordinator.swift
//  UHP zadatak
//
//  Created by Mateo Doslic on 24/10/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    let window: UIWindow
    //root navigation controller
    var presenter: UINavigationController
    init(window: UIWindow) {
        self.window = window
        presenter = UINavigationController()
        
    }
    
    func start() {
        window.rootViewController = presenter
        window.makeKeyAndVisible()
        let homeCoordinator = HomeCoordinator(presenter: presenter)
        addChildCoordinator(childCoordinator: homeCoordinator)
        homeCoordinator.start()
    }
}
