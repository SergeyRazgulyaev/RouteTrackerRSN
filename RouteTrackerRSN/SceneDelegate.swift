//
//  SceneDelegate.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 02.04.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
                
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        if let realmManager = RealmManager.instance {
            let logInScreenViewController = LogInScreenViewController(realmManager: realmManager)
            window?.rootViewController = logInScreenViewController
            window?.makeKeyAndVisible()
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        showSecurityCurtain()
    }
    
    func showSecurityCurtain() {
        guard let window = self.window else {
            return
        }
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window.frame
        blurEffectView.tag = 787
        
        self.window?.addSubview(blurEffectView)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        hideSecurityCurtain()
    }
    
    func hideSecurityCurtain() {
        self.window?.viewWithTag(787)?.removeFromSuperview()
    }
}

