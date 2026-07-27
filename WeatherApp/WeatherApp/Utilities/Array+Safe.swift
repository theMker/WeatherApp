import Foundation

extension Array {
    /// Returns the element at `index`, or `nil` if the index is out of bounds.
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
