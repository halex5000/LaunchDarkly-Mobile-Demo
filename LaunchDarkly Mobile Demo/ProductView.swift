//
//  ProductView.swift
//  LaunchDarkly Mobile Demo
//
//  Created by Alex Hardman on 4/27/23.
//

import SwiftUI

struct ToastView: View {
    let message: String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.black)
                .cornerRadius(20)
        }
        .opacity(isPresented ? 1 : 0)
        .animation(.easeInOut(duration: 0.5))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isPresented = false
            }
        }
    }
}

struct ProductView: View {
    @EnvironmentObject var featureFlagViewModel: FeatureFlagViewModel
    
    let product: Product
    
    let sohneFont = Font.custom("Söhne Buch", size: 20)
    
    let maxWidth: CGFloat = 150
    
    @State private var showAlert = false
    @State private var alertMessage = "Oh no! Something went wrong..."
    @State private var showToast = false
    
    var body: some View {
        ZStack (alignment: .center) {
            Rectangle().stroke(Color(red: 40/255, green: 40/255, blue: 40/255), lineWidth: 1)
            VStack(spacing: 10) {
                Image(product.priceId)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: maxWidth)
                
                Text(product.name)
                    .font(sohneFont).fontWeight(.bold).foregroundColor(Color(red: 40/255, green: 40/255, blue: 40/255))
                    .frame(maxWidth: maxWidth, alignment: .center)
                    
                if showToast {
                    ToastView(message: "Added!", isPresented: $showToast)
                }
                
                if featureFlagViewModel.isPaymentEnabled {
                    Button("Add to Cart", action: addToCart)
                        .padding()
                        .background(Color(cgColor: UIColor(red: 0.251, green: 0.357, blue: 1, alpha: 1).cgColor))
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 5)
                        .buttonStyle(DefaultButtonStyle())
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .frame( maxWidth: 200, maxHeight: 200)
    }
    
    func addToCart() {
        if !featureFlagViewModel.isPaymentServiceEnabled {
            showAlert = true
        } else {
            self.showToast = true
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var product = Inventory.sampleData[1]
    static var featureFlagViewModel = FeatureFlagViewModel()
    static var previews: some View {
        ProductView(product: product)
            .environmentObject(featureFlagViewModel)
    }
}
