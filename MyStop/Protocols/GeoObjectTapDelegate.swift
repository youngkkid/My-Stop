import Foundation
import YandexMapsMobile

protocol GeoObjectTapDelegate: AnyObject {
    
func didTapGeoObject(_ geoObject: YMKGeoObject)
    
}
