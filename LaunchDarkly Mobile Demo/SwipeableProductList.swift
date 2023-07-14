//
//  SwipeableProductList.swift
//  LaunchDarkly Mobile Demo
//
//  Created by Alex Hardman on 5/1/23.
//

import SwiftUI

struct SwipeableProductList: View {
    var products: [Product]
    var title: String
    var body: some View {
        VStack {
            Text(title).font(.headline).padding(.horizontal)
            ScrollView (.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(products, id: \.priceId) { product in
                        ProductView(product: product)
                    }
                }
            }
        }
        .shadow(color: title == "Featured" ? Color(red: 163/255, green: 79/255, blue: 222/255) : Color.gray.opacity(0.4), radius: 10, x: 0, y: 2)
    }
}

struct SwipeableProductList_Previews: PreviewProvider {
    static var previews: some View {
        SwipeableProductList(products: Inventory.sampleData, title: "Products")
    }
}
