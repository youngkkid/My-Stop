import Foundation
import YandexMapsMobile

final class MapService {
    private weak var map: YMKMap?
    private var stopPlaceMarks: [UUID: YMKPlacemarkMapObject] = [:]
    
    init(map: YMKMap) {
        self.map = map
    }
    
    func refreshPlaceMarks(stops: [BusStopItemModel]) {
        stopPlaceMarks.values.forEach { $0.parent.remove(with: $0)}
        stopPlaceMarks.removeAll()
        
        stops.forEach {addPlaceMarkOnMap(for: $0)}
    }
    
    private func addPlaceMarkOnMap(for stop: BusStopItemModel) {
        guard let map = map else {return}
        let placeMark = map.mapObjects.addPlacemark()
        placeMark.geometry = YMKPoint(latitude: stop.latitude, longitude: stop.longitude)
        placeMark.setIconWith(UIImage(resource: .pin))
        stopPlaceMarks[stop.id] = placeMark
        
        print("Added placemark for stop: \(stop.street), lat: \(stop.latitude), lon: \(stop.longitude)")
    }
}
