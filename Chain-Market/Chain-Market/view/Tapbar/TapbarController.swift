//
//  TapbarController.swift
//  Chain-Market
//
//  Created by 오경식 on 2022/12/15.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    let listViewController = MarketListViewController()
    let listTabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
    lazy var listNavigationController = UINavigationController(rootViewController: self.listViewController)

    let registrationTabView = RegistrationViewController()
    let registrationTabBarItem = UITabBarItem(title: "등록", image: UIImage(systemName: "plus.app"), tag: 1)
    lazy var registrationController = UINavigationController(rootViewController: self.registrationTabView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listNavigationController.tabBarItem = listTabBarItem
        registrationController.tabBarItem = registrationTabBarItem

        setViewControllers([listNavigationController, registrationController], animated: true)
        delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            listNavigationController.pushViewController(registrationTabView, animated: true)
            return false
        }
        return true
    }
}
