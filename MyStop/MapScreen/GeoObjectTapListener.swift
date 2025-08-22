import Foundation
import YandexMapsMobile

// класс для взаимодействия с POI (points of interest), при нажатии на которые можно получать краткую инфу

final class GeoObjectTapListener: NSObject, YMKLayersGeoObjectTapListener {
    
    weak var delegate: GeoObjectTapDelegate?
    
    init(delegate: GeoObjectTapDelegate) {
        self.delegate = delegate
    }
    
    func onObjectTap(with event: YMKGeoObjectTapEvent) -> Bool {
        guard let delegate = delegate else {return false}
        
        delegate.didTapGeoObject(event.geoObject)
        
        return true
    }
    
    
}
