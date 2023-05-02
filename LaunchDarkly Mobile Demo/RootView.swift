import SwiftUI

struct RootView: View {
    @EnvironmentObject var commonStyles: CommonStyles
    @EnvironmentObject var featureFlagViewModel: FeatureFlagViewModel
    @EnvironmentObject var productViewModel: ProductViewModel

    var body: some View {
        VStack {
            Image("high-five")
        }.padding().frame(alignment: .center)
    }
}
