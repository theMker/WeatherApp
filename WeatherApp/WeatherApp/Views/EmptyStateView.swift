import SwiftUI

struct EmptyStateView: View {
    @Binding var isShowingSearch: Bool

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No Saved Cities")
                .font(.headline)
            Text("Search for a city to see its forecast and add it to your list.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button("Search for a City") {
                isShowingSearch = true
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
