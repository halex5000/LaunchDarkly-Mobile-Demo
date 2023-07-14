import SwiftUI
import LaunchDarkly

struct NewLoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedUser: String = ""
    var featureFlagViewModel: FeatureFlagViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Picker(selection: $selectedUser, label: Text("Select a login option")) {
                Text("Anonymous").tag("Anonymous")
                Text("Dev tester").tag("Dev Tester")
            }
            .pickerStyle(WheelPickerStyle())
            
            Button(action: {
                   // Perform some action based on the selected user
                   switch selectedUser {
                       case "Anonymous":
                           // Perform login for anonymous user
                           featureFlagViewModel.logout()
                       case "Dev Tester":
                           // Perform login for dev tester
                           featureFlagViewModel.loginDevTester()
                       default:
                           print("selected user is: " + selectedUser)
                           break
                   }
                   // Dismiss the view after login is complete
                   presentationMode.wrappedValue.dismiss()
                   isPresented = false
               }) {
                   Text("Complete Login")
               }
               .padding()
               .background(Color(cgColor: UIColor(red: 0.251, green: 0.357, blue: 1, alpha: 1).cgColor))
               .foregroundColor(Color.white)
               .cornerRadius(10)
        }.transition(.move(edge: .bottom))
    }
}

struct InventoryView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var commonStyles: CommonStyles
    @EnvironmentObject var featureFlagViewModel: FeatureFlagViewModel
    @State private var isShowingLoginView = false
    
    @State private var isLoggedIn = false
    
    var body: some View {
        ZStack {
            VStack {
                if featureFlagViewModel.isNewStoreExperience {
                    if productViewModel.isLoading {
                        VStack {
                            Image("high-five").resizable().scaledToFit().frame(alignment: .center)
                            Text("Loading...").font(.headline)
                        }
                    } else {
                        VStack {
                            HStack {
                                AppHeaderView()
                            }
                            if featureFlagViewModel.isFeaturedEnabled {
                                ScrollView {
                                    if productViewModel.featured.count > 0 {
                                        SwipeableProductList(products: productViewModel.featured, title: featureFlagViewModel.featuredProductSectionTitle.uppercased())
                                    }
                                    
                                    if featureFlagViewModel.isGogglesEnabled && productViewModel.goggles.count > 0 {
                                        SwipeableProductList(products: productViewModel.goggles, title: "Goggles")
                                    }
                                    
                                    if productViewModel.toggles.count > 0 {
                                        SwipeableProductList(products: productViewModel.toggles, title: "Toggles")
                                    }
                                }
                            } else {
                                ScrollView {
                                    if featureFlagViewModel.isGogglesEnabled && productViewModel.goggles.count > 0 {
                                        SwipeableProductList(products: productViewModel.goggles, title: "Goggles")
                                    }
                                    
                                    if productViewModel.toggles.count > 0 {
                                        SwipeableProductList(products: productViewModel.toggles, title: "Toggles")
                                    }
                                }
                            }
                            HStack {
                                Button(isLoggedIn ? "Logout" : "Login as Tester" , action: {
                                    if isLoggedIn {
                                        featureFlagViewModel.logout()
                                        isLoggedIn = false
                                    } else {
                                        featureFlagViewModel.loginDevTester()
                                        isLoggedIn = true
                                    }
                                })
                                .padding(.horizontal)
                                .background(Color(cgColor: UIColor(red: 0.251, green: 0.357, blue: 1, alpha: 1).cgColor))
                                .foregroundColor(Color.white)
                                .cornerRadius(5)
                                .shadow(radius: 5)
                                .buttonStyle(DefaultButtonStyle())
                            }
                        }
                    }
                    
                }
                else {
                    VStack {
                        OldProductListView()
                    }
                }
            }
        }.sheet(isPresented: $isShowingLoginView) {
            NewLoginView(featureFlagViewModel: featureFlagViewModel, isPresented: $isShowingLoginView)
        }
    }
}

struct InventoryView_Previews: PreviewProvider {
//    static var products = Inventory.sampleData
    static var featureFlagViewModel = FeatureFlagViewModel()
    static var productViewModel = ProductViewModel(featureFlagViewModel: featureFlagViewModel)
    static var commonStyles = CommonStyles()
    static var previews: some View {
        InventoryView()
            .environmentObject(featureFlagViewModel)
            .environmentObject(productViewModel)
            .environmentObject(commonStyles)
    }
}
