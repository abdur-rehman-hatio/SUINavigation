//
//  NavigationUtils.swift
//
//
//  Created by Sergey Balalaev on 09.06.2022.
//

import UIKit

public enum NavigationUtils {

    private static var firstKeyWindow: UIWindow? {
        UIApplication.shared
            .connectedScenes
            .lazy
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    public static func popToRootView() {
        navigationController()?.popToRootViewController(animated: true)
    }

    public static func popTo(index: Int) {
        guard let navController = navigationController(),
            index < navController.viewControllers.count else {
            return
        }
        navController.popToViewController(navController.viewControllers[index], animated: true)
    }

    public static func navigationController() -> UINavigationController? {
        findController(viewController: rootController())
    }

    public static func tabBarController() -> UITabBarController? {
        findController(viewController: rootController())
    }

    public static func rootController() -> UIViewController? {
        guard var topController = firstKeyWindow?.rootViewController else {
            return nil
        }
        // Follow modal presentations (e.g. a host app presenting the SDK's
        // UIHostingController via `.present(...)`) down to the deepest one,
        // since `.presentedViewController` is not part of `.children`.
        while let presented = topController.presentedViewController {
            topController = presented
        }
        return topController
    }

    public static func findController<T: UIViewController>(viewController: UIViewController?) -> T? {
        guard let viewController = viewController else {
            return nil
        }

        if let matched = viewController as? T {
            return matched
        }

        for childViewController in viewController.children {
            if let found: T = findController(viewController: childViewController) {
                return found
            }
        }

        if let presented = viewController.presentedViewController,
           let found: T = findController(viewController: presented) {
            return found
        }

        return nil
    }

    public static func present(_ viewController: UIViewController) {
        guard let presenterController = navigationController() else {
            return
        }

        presenterController.present(viewController, animated: true)
    }
}
