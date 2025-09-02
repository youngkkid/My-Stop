//import Foundation
//import YandexMapsMobile
//
//final class MapViewModel {
//    
//    private let repository: BusStopsRepository
//    
//    private(set) var stops: [BusStopItemModel] = [] {
//        didSet {
//            onStopsUpdated?(stops)
//        }
//    }
//    
//    var onStopsUpdated: (([BusStopItemModel]) -> Void)?
////    var onNewStopSelected: ((BusStopItemModel) -> Void)?
//    
//    init(repository: BusStopsRepository) {
//        self.repository = repository
//        stops = repository.stops
//    }
//    
//    func selectedGeoObject(_ geoObject: YMKGeoObject) -> BusStopItemModel {
//        let name = geoObject.name ?? "Неизвестная остановка"
//        let latitude = geoObject.geometry.first?.point?.latitude ?? 0.0
//        let longitude = geoObject.geometry.first?.point?.longitude ?? 0.0
//        
//      return BusStopItemModel(street: name, latitude: latitude, longitude: longitude)
//    }
//    
//    func addStop(_ stop: BusStopItemModel) {
//        repository.addStop(stop)
//        stops = repository.stops
//        repository.saveStops()
//        onStopsUpdated?(stops)
//    }
//    
//    func removeStop(_ stop: BusStopItemModel) {
//        repository.removeStop(stop)
//        repository.saveStops()
//        stops = repository.stops
//    }
//    
//    func loadInitialStops() {
//        stops = repository.stops
//        onStopsUpdated?(stops)
//    }
//    
////    private func saveMarks() {
////        if let data = try? JSONEncoder().encode(stops) {
////            UserDefaults.standard.set(data, forKey: "markStops")
////        }
////    }
////    
////    private func loadMarks() -> [BusStopItemModel] {
////        guard let data = UserDefaults.standard.data(forKey: "markStops"),
////              let marks = try? JSONDecoder().decode([BusStopItemModel].self, from: data) else {
////            return []
////        }
////        return marks
////    }
//}
