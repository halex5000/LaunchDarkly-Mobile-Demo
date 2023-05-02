//
//  LaunchDarkly_Mobile_DemoApp.swift
//  LaunchDarkly Mobile Demo
//
//  Created by Alex Hardman on 4/27/23.
//

import SwiftUI

@main
struct LaunchDarkly_Mobile_DemoApp: App {
    var featureFlagViewModel: FeatureFlagViewModel!
    var productViewModel: ProductViewModel!
    var commonStyles: CommonStyles!
    
    init() {
        featureFlagViewModel = FeatureFlagViewModel()
        commonStyles = CommonStyles()
        productViewModel = ProductViewModel(featureFlagViewModel: featureFlagViewModel)
    }
    
    var body: some Scene {
        WindowGroup {
            InventoryView()
                .environmentObject(commonStyles)
                .environmentObject(featureFlagViewModel)
                .environmentObject(productViewModel)
        }
    }
}
