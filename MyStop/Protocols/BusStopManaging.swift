import Foundation
import YandexMapsMobile

protocol BusStopManaging: AnyObject {
    var stops: [BusStopItemModel] {get}
    func notifyObservers()
    func addObserver(_ observer: @escaping ([BusStopItemModel]) -> Void)
    func selectedGeoObject(_ geoObject: YMKGeoObject) -> BusStopItemModel
    func addStop(_ stop: BusStopItemModel)
    func removeStop(_ stop: BusStopItemModel)
}
