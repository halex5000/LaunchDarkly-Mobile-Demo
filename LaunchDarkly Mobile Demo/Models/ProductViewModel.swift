//
//  ProductViewModel.swift
//  LaunchDarkly Mobile Demo
//
//  Created by Alex Hardman on 5/1/23.
//

import Foundation
import LaunchDarkly

class ProductViewModel: ObservableObject {
    @Published private(set) var allProducts: [Product] = []
    @Published private(set) var isLoading = false
    @Published private(set) var goggles: [Product] = []
    @Published private(set) var toggles: [Product] = []
    @Published private(set) var featured: [Product] = []

    private let featureFlagViewModel: FeatureFlagViewModel

    init(featureFlagViewModel: FeatureFlagViewModel) {
        self.featureFlagViewModel = featureFlagViewModel
        loadData()

//        LDClient.get()!.observe(keys: ["is"], owner: self, handler: { [self] changedFlags in
//            if changedFlags["featured-product-label"] != nil {
//                loadData()
//            }
//        })
//
//
//        LDClient.get()!.observe(keys: ["is"], owner: self, handler: { [self] changedFlags in
//            if changedFlags["new-product-experience-access"] != nil {
//                loadData()
//            }
//        })
//
//
//        LDClient.get()!.observe(keys: ["is"], owner: self, handler: { [self] changedFlags in
//            if changedFlags["new-product-experience-access"] != nil {
//                loadData()
//            }
//        })
    }

    func loadData() {
        guard !isLoading else {return}

        isLoading = true

        print("loading data")

        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                var products = try decoder.decode([Product].self, from: data)

                self.allProducts = products
                print("total product count: " + String(self.allProducts.count))

                self.featured = Array(products.prefix(Int(Double(products.count) * 0.25)))
                print("featured product count: " + String(self.featured.count))

                self.toggles = products.filter { $0.category == "toggle" }
                print("toggle product count: " + String(self.toggles.count))

                self.goggles = products.filter { $0.category == "goggle" }
                print("goggle product count: " + String(self.goggles.count))
            } catch {
                print(error)
            }
        } else {
            print("data.json not found in app bundle")
        }

        self.isLoading = false
    }
}
