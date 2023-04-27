//
//  ProductView.swift
//  LaunchDarkly Mobile Demo
//
//  Created by Alex Hardman on 4/27/23.
//

import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
    
}

struct ProductView: View {
    let product: Product
    
    var body: some View {
        HStack (alignment: .center) {
            Image(product.id)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Divider()
                Text(product.description)
                    .font(.caption)
                    .foregroundColor(Color(red: 230/255, green: 230/255, blue: 230/255))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 40/255, green: 40/255, blue: 40/255))
        .modifier(CardModifier())
    }
}

struct ProductView_Previews: PreviewProvider {
    static var product = Inventory.sampleData[1]
    static var previews: some View {
        ProductView(product: product)
    }
}
