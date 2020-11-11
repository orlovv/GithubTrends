//
//  SceneDelegate.swift
//  GithubTrends
//
//  Created by Vladimir Orlov on 09.11.2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = makeNavController()
        window?.makeKeyAndVisible()
    }
    
    private func makeNavController() -> UINavigationController {
        let navigationController = UINavigationController()
        let chartsVC = RepoChartsViewController()
        chartsVC.title = "Swift charts"
        navigationController.pushViewController(chartsVC, animated: true)
        return navigationController
    }
}

