//
//  TapbarController.swift
//  Chain-Market
//
//  Created by 오경식 on 2022/12/15.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    let ListViewController = MarketListViewController()
    let listTabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
    lazy var listNavigationController = UINavigationController(rootViewController: self.ListViewController)

    let RegistrationTabView = RegistrationViewController()
    let RegistrationTabBarItem = UITabBarItem(title: "등록", image: UIImage(systemName: "plus.app"), tag: 1)
    lazy var registrationController = UINavigationController(rootViewController: self.RegistrationTabView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listNavigationController.tabBarItem = listTabBarItem
        registrationController.tabBarItem = RegistrationTabBarItem

        setViewControllers([listNavigationController, registrationController], animated: true)
        delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            listNavigationController.pushViewController(RegistrationTabView, animated: true)
            return false
        }
        return true
    }
}
