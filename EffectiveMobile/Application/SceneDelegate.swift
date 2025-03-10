//
//  SceneDelegate.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let rootViewController = ToDoListModuleConfigurator.configure()
        let navigationController = UINavigationController(rootViewController: rootViewController)

        window.rootViewController = navigationController
        window.overrideUserInterfaceStyle = .dark
        self.window = window
        window.makeKeyAndVisible()
    }
}

