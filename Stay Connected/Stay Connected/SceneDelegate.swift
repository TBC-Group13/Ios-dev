import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Initialize the main window
        let window = UIWindow(windowScene: windowScene)

        // Set SplashViewController as the root view controller
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController

        // Make the window visible
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Restart tasks paused or not started when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Pause ongoing tasks and disable timers.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Undo changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save application state and release shared resources.
    }
}
