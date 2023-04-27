import SwiftUI
import LaunchDarkly

struct StripeResponse: Codable {
    var object: String
    var data: [Product]
}

class ProductsDataModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading = false
    
    func loadData() async {
        guard !isLoading else {return}

        isLoading = true

        print("loading data")

        var request = URLRequest(url: URL(string: "https://api.stripe.com/v1/products")!,timeoutInterval: Double.infinity)
        request.addValue("Basic c2tfdGVzdF81MU1yNlhzQURBT1Q5Rm1uVWZ4N2xobWw2VmRKWGxacEtqQURYYUI3WjBpTkhiZ0FuRWpxdzlndWJYRUZyQ0NId0FZNWxQZUZ6enFRdDBlR1c3MGRVcGk3UjAwa0RNc0Z1VUM6", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) {
          data, response, error in

          let decoder = JSONDecoder()

            if let data = data {
                do{
                    let response = try decoder.decode(StripeResponse.self, from: data)
                    self.products = response.data
                }catch{
                    print(error)
                }
            } else {
                print(String(describing: error))
                return
          }
            self.isLoading = false
        }

        task.resume()
    }
}

class FeatureFlagProvider: ObservableObject {
    @Published private(set) var isNewStoreExperience = false
    
    @Published private(set) var isInitialized = false;
    
    let flagKey = "storeEnabled"
    
    func setupLDClient() {
        var contextBuilder = LDContextBuilder(key: "context-key-123abc")
        
        contextBuilder.trySetValue("firstName", .string("Alex"))
        contextBuilder.trySetValue("lastName", .string("Hardman"))
        contextBuilder.trySetValue("groups", .array([.string("beta-testers")]))
        
        guard case .success(let context) = contextBuilder.build()
        else {return}
        
        var config = LDConfig(mobileKey: "mob-5af368e3-9b18-4f21-9b95-02cb9333d479")
        config.eventFlushInterval = 30.0
        
        if !isInitialized {
            print("setting up the LD client, wish me luck!")
            isInitialized = true;
            LDClient.start(config: config, context: context, startWaitSeconds: 5) { timedOut in
                if timedOut {
                    print("timed out")
                } else {
                    print("successfully initialized")
                }
            }
        }
    }
}

struct InventoryView: View {
    @State private var products = Inventory.sampleData
    @StateObject private var dataModel = ProductsDataModel()
    @StateObject private var featureFlagProvider = FeatureFlagProvider()
    
    @State private(set) var isNewStoreExperience = false
    
    var body: some View {
        HStack {
            if isNewStoreExperience {
                VStack {
                    HStack {
                        if dataModel.isLoading {
                            Image("high-five")
                        }
                        Text("Toggle Outfitters")
                            .font(.title).fontWeight(.heavy).fontDesign(.serif)
                            .foregroundColor(Color(red: 40/255, green: 40/255, blue: 40/255))
                        if !dataModel.isLoading {
                            Image("high-five").resizable().aspectRatio(contentMode: .fit).frame(width: 150, height: 150)
                        }
                    }
                    
                    List(dataModel.products, id: \.id) { product in
                        ProductView(product: product)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .task {
                    await dataModel.loadData()
                }
            }
            else {
                VStack {
                    HStack {
                        Text("Toggle Outfitters")
                            .font(.title).fontWeight(.heavy).fontDesign(.serif)
                            .foregroundColor(Color(red: 40/255, green: 40/255, blue: 40/255))
                        Image("high-five").resizable().aspectRatio(contentMode: .fit).frame(width: 150, height: 150)
                    }
                    
                    List(Inventory.sampleData, id: \.id) { product in
                        ProductView(product: product)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }.onAppear() {
            featureFlagProvider.setupLDClient()
            isNewStoreExperience = LDClient.get()!.boolVariation(forKey: "storeEnabled", defaultValue: false);
            
            LDClient.get()!.observe(keys: ["storeEnabled"], owner: isNewStoreExperience as LDObserverOwner, handler: { [self] changedFlags in
                if changedFlags["storeEnabled"] != nil {
                    print("something changed")
                    let something = LDClient.get()!.boolVariation(forKey: "storeEnabled", defaultValue: false)
                    print("the new value is: ", something)
                    isNewStoreExperience = something
                }
            })
        }
        .task {
            await dataModel.loadData()
        }
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var products = Inventory.sampleData
    static var previews: some View {
        InventoryView()
    }
}



//class StripeResponseModel: ObservableObject {
//    @Published private(set) var products: [Product] = []
//    @Published private(set) var isLoading = false;
//    
//    func loadData() async {
//        guard !isLoading else {return}
//        
//        isLoading = true
//        
//        print("loading data")
//        
//        var request = URLRequest(url: URL(string: "https://api.stripe.com/v1/products")!,timeoutInterval: Double.infinity)
//        request.addValue("Basic c2tfdGVzdF81MU1yNlhzQURBT1Q5Rm1uVWZ4N2xobWw2VmRKWGxacEtqQURYYUI3WjBpTkhiZ0FuRWpxdzlndWJYRUZyQ0NId0FZNWxQZUZ6enFRdDBlR1c3MGRVcGk3UjAwa0RNc0Z1VUM6", forHTTPHeaderField: "Authorization")
//
//        request.httpMethod = "GET"
//
//        let task = URLSession.shared.dataTask(with: request) {
//          data, response, error in
//            
//          let decoder = JSONDecoder()
//            
//            if let data = data {
//                do{
//                    let response = try decoder.decode(StripeResponse.self, from: data)
//                    products = response.data
//                }catch{
//                    print(error)
//                }
//            } else {
//                print(String(describing: error))
//                return
//          }
//        }
//
//        task.resume()
//    }
//}
//
//struct HomeView: View {
//    @StateObject var products: [Product] = [Product]([Product(id: "poop", description: "poopy", name: "poopster")])
//    
//    var body: some View {
//        List(products) { product in
//            Text(product.name)
//        }
//    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        HomeView(products: [Product]([Product(id: "poop", description: "poopy", name: "poopster")]))
//    }
//}
