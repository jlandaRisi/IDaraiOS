import SwiftUI

struct SayHelloView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Hello everyone!")
                .font(.title)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

#Preview {
    SayHelloView()
}
