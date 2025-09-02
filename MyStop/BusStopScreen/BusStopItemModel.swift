import Foundation

struct BusStopItemModel: Codable, Hashable, Equatable {
    let id: UUID
    let street: String
    let latitude: Double
    let longitude: Double
    
    init(street: String, latitude: Double, longitude: Double) {
        self.id = UUID()
        self.street = street
        self.latitude = latitude
        self.longitude = longitude
    }
}

