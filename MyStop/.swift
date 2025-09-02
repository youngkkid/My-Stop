import Foundation

final class BusStopsRepository {
    private(set) var stops: [BusStopItemModel] = []
    
    init() {
        stops = loadStops()
    }
    
    func loadStops() -> [BusStopItemModel] {
        guard let data = UserDefaults.standard.data(forKey: "busStops"),
              let stops = try? JSONDecoder().decode([BusStopItemModel].self, from: data) else {
            return []
        }
        return stops
    }
    
    func addStop(_ stop: BusStopItemModel) {
        stops.append(stop)
        saveStops()
    }
    
    func removeStop(_ stop: BusStopItemModel) {
        stops.removeAll{$0.id == stop.id}
        saveStops()
    }
    
    func saveStops() {
        if let data = try? JSONEncoder().encode(stops) {
            UserDefaults.standard.set(data, forKey: "busStops")
        }
    }
}
