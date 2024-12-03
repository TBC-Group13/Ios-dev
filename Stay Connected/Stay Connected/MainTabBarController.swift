//
//  MainTabBarController.swift
//  Stay Connected
//
//  Created by Anna Harris on 03.12.24.
//

import UIKit

class MainTabBarController: UITabBarController {

    private let loggedInUserViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        self.navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: TabBar Setup
    private func setupTabBar() {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: UIImage(systemName: "house.fill"))

        let leaderboardViewController = ViewController()
        leaderboardViewController.tabBarItem = UITabBarItem(title: "Leaderboard", image: UIImage(systemName: "star.fill"), selectedImage: UIImage(systemName: "star.fill"))

        let profileViewController = ViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"))

        let controllers = [
            homeViewController,
            leaderboardViewController,
            profileViewController
        ]

        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }

        tabBar.backgroundColor = UIColor(white: 0.9, alpha: 0.2)
        tabBar.tintColor = UIColor.black
        tabBar.unselectedItemTintColor = UIColor(white: 0.3, alpha: 1.0)
    }

    
}
