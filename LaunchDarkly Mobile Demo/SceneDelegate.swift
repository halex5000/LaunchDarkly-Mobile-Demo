import UIKit
import SwiftUI
import LaunchDarkly

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var featureFlagViewModel: FeatureFlagViewModel!
    var productViewModel: ProductViewModel!
    var commonStyles: CommonStyles!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print(
        """
        pooooooooooooooooooooop
        """
        )
        // Create a new UIWindowScene
        guard let windowScene = scene as? UIWindowScene else { return }
        // Create a new UIWindow using the UIWindowScene
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        featureFlagViewModel = FeatureFlagViewModel()
        
        commonStyles = CommonStyles()
        productViewModel = ProductViewModel(featureFlagViewModel: featureFlagViewModel)
        let rootView = NavigationView {
            InventoryView()
                .environmentObject(commonStyles)
                .environmentObject(featureFlagViewModel)
                .environmentObject(productViewModel)
        }
        
        // Set the EnvironmentObject for the NavigationView
        rootView.environmentObject(featureFlagViewModel)

        // Set the root view of the window to your root view
        window.rootViewController = UIHostingController(rootView: rootView)

        // Make the window visible
        window.makeKeyAndVisible()
    }
}
