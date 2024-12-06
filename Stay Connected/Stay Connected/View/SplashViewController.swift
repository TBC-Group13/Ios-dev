//
//  SplashViewController.swift
//  Stay Connected
//
//  Created by Giorgi Matiashvili on 30.11.24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashScreen()
        animateSplashScreen()
    }

    private func setupSplashScreen() {
        view.backgroundColor = UIColor(red: 0.31, green: 0.33, blue: 0.64, alpha: 1.0) // #4E53A2

        let hotspotIcon = UIImageView()
        hotspotIcon.translatesAutoresizingMaskIntoConstraints = false
        hotspotIcon.image = UIImage(systemName: "personalhotspot")
        hotspotIcon.tintColor = .white
        hotspotIcon.contentMode = .scaleAspectFit
        view.addSubview(hotspotIcon)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Stay Connected"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            hotspotIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hotspotIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            hotspotIcon.widthAnchor.constraint(equalToConstant: 118),
            hotspotIcon.heightAnchor.constraint(equalToConstant: 90),

            titleLabel.topAnchor.constraint(equalTo: hotspotIcon.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func animateSplashScreen() {
        if let hotspotIcon = view.subviews.first(where: { $0 is UIImageView }) {
            hotspotIcon.alpha = 0
            UIView.animate(withDuration: 1.5, animations: {
                hotspotIcon.alpha = 1
            })
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.moveToLoginPage()
        }
    }

    private func moveToLoginPage() {
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)

        UIView.transition(with: self.view.window ?? UIWindow(),
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                              UIApplication.shared.windows.first?.rootViewController = navigationController
                          },
                          completion: nil)
    }
}
