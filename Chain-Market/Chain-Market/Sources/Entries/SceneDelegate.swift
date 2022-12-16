//
//  SceneDelegate.swift
//  ChainMarket
//
//  Created by 오경식 on 2022/11/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let chainMarketTab = TabBarController()

        window?.rootViewController = chainMarketTab
        window?.makeKeyAndVisible()
    }
}
