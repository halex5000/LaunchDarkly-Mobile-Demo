//
//  CommonStyles.swift
//  LaunchDarkly Mobile Demo
//
//  Created by Alex Hardman on 5/1/23.
//

import SwiftUI

class CommonStyles: ObservableObject {
    @Published var gradient = LinearGradient(gradient: Gradient(colors: [Color(red: 237/255, green: 244/255, blue: 201/255), Color(red: 158/255, green: 173/255, blue: 241/255)]), startPoint: .leading, endPoint: .trailing)
    
    @Published var titleFont = Font.custom("Audimat3000-Regulier", size: 60)
    
    @Published var title = "Toggle Outfitters"
    
    @Published var black = Color(red: 40/255, green: 40/255, blue: 40/255)
}
