import UIKit
import SnapKit
import YandexMapsMobile

final class MapViewController: UIViewController, GeoObjectTapDelegate {
    
    var onBusStopSelected: ((BusStopItemModel) -> Void)?
    
    private let mapView = YMKMapView()
    
    
    // экземпляр класса, из которого имплементируем метод инфы о пине
    private lazy var mapObjectTapListener: YMKMapObjectTapListener = MapObjectTapListener(controller: self)
    
    // экземпляр класса, из которого имплементируем  метод инфы о POI
    private lazy var geoObjectTapListener: YMKLayersGeoObjectTapListener = GeoObjectTapListener(delegate: self)
    
    private lazy var addNewPointButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать остановку", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(addNewPointButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupMapView()
        setupCamera()
        initialize()
        
        addPlacemark(mapView.mapWindow.map)
        addGeoObjectListener(mapView.mapWindow.map)
    }
    
    func didTapGeoObject(_ geoObject: YMKGeoObject) {
        let name = geoObject.name ?? "Неизвестное место"
        
        AlertManager.shared.showPinInfo(with: name, message: "", from: self) {[weak self] in
            guard let self = self else {return}
            
            let newStop = BusStopItemModel(street: name, busses: "1, 2, 3")
            self.onBusStopSelected?(newStop)
        }
    }
    
    private func setupMapView() {
           view.addSubview(mapView)
           mapView.snp.makeConstraints { make in
               make.edges.equalToSuperview()
           }
       }
    
    private func setupCamera() {
        let map = mapView.mapWindow.map
        
        map.move(
                    with: YMKCameraPosition(
                        target: YMKPoint(latitude: 55.751225, longitude: 37.62954),
                        zoom: 15,
                        azimuth: 0,
                        tilt: 0
                    ),
                    animation: YMKAnimation(type: .smooth, duration: 5),
                    cameraCallback: nil
                )
    }
    
    // метод добавления метки
    private func addPlacemark(_ map: YMKMap) {
        let image = UIImage(resource: .pin)
        let placemark = map.mapObjects.addPlacemark()
        placemark.geometry = YMKPoint(latitude: 55.751225, longitude: 37.62954)
        placemark.setIconWith(image)
        
        placemark.setTextWithText(
            "Test mark",
            style: YMKTextStyle(
                size: 10.0,
                color: .black,
                outlineWidth: 10.0,
                outlineColor: .white,
                placement: .top,
                offset: 0.0,
                offsetFromIcon: true,
                textOptional: false
            )
        )
        
        placemark.addTapListener(with: mapObjectTapListener)
    }
    
    private func addGeoObjectListener(_ map: YMKMap) {
    map.addTapListener(with: geoObjectTapListener)
    }
    
    @objc
    private func addNewPointButtonTapped() {
        print("Нажатие")
    }
}

extension MapViewController {
    private func initialize() {
        view.addSubview(addNewPointButton)
        
        addNewPointButton.snp.makeConstraints {make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(26)
            make.height.equalTo(50)
            make.width.equalTo(114)
        }
    }
}
