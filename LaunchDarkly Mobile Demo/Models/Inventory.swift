//
//  Inventory.swift
//  LaunchDarkly Mobile Demo
//
//  Created by Alex Hardman on 4/27/23.
//

import Foundation

struct Product: Codable {
    var id: Int
    var description: String
    var name: String
    var priceId: String
    var category: String
    var isFeatured: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case description = "description"
        case name = "product_id"
        case priceId = "price_id"
        case category = "category"
    }
}

struct Inventory {
    var products: [Product]
}

extension Inventory {
    static let sampleData: [Product] = [
//        Product(id: "prod_NhEWaTc3roDlfh", description: "No need to avoid the limelight in these goggles.", name: "Shady Goggles", image: "dark-glasses"),
//        Product(id: "prod_NhEWSMmlMu61Go", description: "Do you play sportball? Doesn't matter. Look like you do in these goggles.", name: "Shiny Goggles", image: "shiny-glasses"),
//        Product(id: "prod_NhEVoiyWW7Uk6x", description: "Look like a star in these gold goggles.", name: "Glimmery Goggles", image: "gold-glasses"),
//        Product(id: "prod_NcjPCZkwwhEUag", description: "We are not liable for horn toggle related injuries, buyer beware.", name: "Horn Toggle", image: "toggle-8"),
//        Product(id: "prod_NcjPt4TDw3hti2", description: "Perfect for whaling outings, definitely not whale bone...", name: "Historic Toggle", image: "toggle-7"),
        Product(id: 1, description: "We are not liable for horn toggle related injuries, buyer beware.", name: "Horn Toggle", priceId: "price_1MrTwpADAOT9FmnUAUCWGjo5", category: "toggle", isFeatured: false),
        Product(id: 2, description: "Perfect for whaling outings, definitely not whale bone...", name: "Historic Toggle", priceId: "price_1MrTwMADAOT9FmnUX16UeeUt", category: "toggle", isFeatured: true),
    ]
}
