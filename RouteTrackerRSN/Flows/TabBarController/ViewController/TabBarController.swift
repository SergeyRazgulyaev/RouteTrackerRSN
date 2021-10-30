//
//  TabBarController.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 11.04.2021.
//

import UIKit
import RealmSwift

class TabBarController: UITabBarController {
    // MARK: - Properties
    private let realmManager: RealmManager
    private let userLogin: String
    
    // MARK: - Init
    init(realmManager: RealmManager, userLogin: String) {
        self.realmManager = realmManager
        self.userLogin = userLogin
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = createViewControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
    }
    
    //MARK: - Configuration Methods
    func configureTabBarController() {
        self.tabBar.barTintColor = .rsnLightBlueColor
        self.tabBar.tintColor = .white
    }
    
    func createViewControllers() -> [UIViewController] {
        var viewControllers = [UIViewController]()
        
        //1. MapScreen
        let mapScreenViewController = MapScreenViewController(realmManager: realmManager, userLogin: userLogin)
        mapScreenViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
        
        let mapScreenNavigationController = UINavigationController(rootViewController: mapScreenViewController)
        viewControllers.append(mapScreenNavigationController)
        
        return viewControllers
    }
}
