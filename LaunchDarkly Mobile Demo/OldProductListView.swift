//
//  OldProductListView.swift
//  LaunchDarkly Mobile Demo
//
//  Created by Alex Hardman on 5/1/23.
//

import SwiftUI

struct OldProductListView: View {
    @StateObject private var commonStyles = CommonStyles()
    var body: some View {
        VStack {
            HStack {
                Text(commonStyles.title)
                    .font(.title).fontWeight(.heavy).fontDesign(.serif)
                    .foregroundColor(commonStyles.black)
                Image("high-five").resizable().aspectRatio(contentMode: .fit).frame(width: 150, height: 150)
            }
            
            List(Inventory.sampleData, id: \.id) { product in
                ProductView(product: product)
            }.frame(width: 250, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct OldProductListView_Previews: PreviewProvider {
    static var previews: some View {
        OldProductListView()
    }
}
