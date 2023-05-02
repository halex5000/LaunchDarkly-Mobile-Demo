//
//  LoginView.swift
//  LaunchDarkly Mobile Demo
//
//  Created by Alex Hardman on 5/1/23.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    let featureFlagViewModel: FeatureFlagViewModel
    
    func login() {
        featureFlagViewModel.login(username: username)
        
        let commonStyles = CommonStyles()
        let productViewModel = ProductViewModel(featureFlagViewModel: featureFlagViewModel)
        let rootView = InventoryView()
            .environmentObject(commonStyles)
            .environmentObject(featureFlagViewModel)
            .environmentObject(productViewModel)
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: rootView)
        }
    }
    
    var body: some View {
        VStack {
            Text("Login").font(.largeTitle)
            TextField("Username", text: $username)
                .padding()
                .border(Color.gray, width: 1)
            
            SecureField("Password", text: $password)
                .padding()
                .border(Color.gray, width: 1)
            
            Button(action: {
                login()
            }, label: {
                Text("Login")
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(5)
            })
            .padding()
        }
    }
}

struct LoginView_Preview: PreviewProvider {
//    static var products = Inventory.sampleData
    static var featureFlagViewModel = FeatureFlagViewModel()
    static var previews: some View {
        LoginView(featureFlagViewModel: featureFlagViewModel)
    }
}
