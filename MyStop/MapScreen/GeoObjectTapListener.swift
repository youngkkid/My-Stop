import Foundation
import YandexMapsMobile

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
