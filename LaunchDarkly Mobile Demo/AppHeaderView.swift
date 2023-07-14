//
//  AppHeaderView.swift
//  LaunchDarkly Mobile Demo
//
//  Created by Alex Hardman on 5/1/23.
//

import SwiftUI

struct AppHeaderView: View {
    @StateObject private var commonStyles = CommonStyles()
    @EnvironmentObject var featureFlagViewModel: FeatureFlagViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(commonStyles.title)
                    .font(commonStyles.titleFont)
                    .foregroundColor(.white)
                    .overlay(
                        Text(commonStyles.title)
                            .font(commonStyles.titleFont)
                            .foregroundColor(.clear)
                            .background(commonStyles.gradient)
                            .mask(Text(commonStyles.title)
                                .font(commonStyles.titleFont)
                                .fontWeight(.bold)
                            )
                    )
                Image("high-five").resizable().aspectRatio(contentMode: .fit).frame(width: 150, height: 150)
                
            }
        }
    }
}

struct AppHeaderView_Previews: PreviewProvider {
    static var featureFlagViewModel = FeatureFlagViewModel()
    static var previews: some View {
        AppHeaderView()
            .environmentObject(featureFlagViewModel)
    }
}
