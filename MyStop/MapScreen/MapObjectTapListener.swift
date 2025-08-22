// класс обработчик, который имплементирует метод для нажатия на метку

import ObjectiveC
import YandexMapsMobile

final class MapObjectTapListener: NSObject, YMKMapObjectTapListener {
    
    weak var controller: UIViewController?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let controller = controller else { return false }
        
        AlertManager.shared.showPinInfo(with: "Тестовая точка", message: "\((point.latitude, point.longitude))", from: controller)
        
        return true
    }
}
