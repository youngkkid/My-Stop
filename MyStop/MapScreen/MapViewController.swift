import UIKit
import SnapKit
import YandexMapsMobile

final class MapViewController: UIViewController, GeoObjectTapDelegate {
    
    // MARK: - Properties
    
    private let mapView = YMKMapView()
    private var userLocationLayer: YMKUserLocationLayer?
    private let manager: BusStopManaging
    private lazy var mapService: MapService = {
        MapService(map: mapView.mapWindow.map)
    }()
    private lazy var geoObjectTapListener: YMKLayersGeoObjectTapListener = GeoObjectTapListener(delegate: self)
    
    // MARK: - Init
    
    init(manager: BusStopManaging) {
        self.manager = manager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupMapView()
        setupCamera()
        setupUserLocation()
        
        addGeoObjectListener(mapView.mapWindow.map)
        
        bindViewModel()
        mapService.refreshPlaceMarks(stops: manager.stops)
    }
    
    // MARK: - Public Methods
    
    func didTapGeoObject(_ geoObject: YMKGeoObject) {
        let stop = manager.selectedGeoObject(geoObject)
        
        AlertManager.shared.showPinInfo(with: stop.street, message: "", from: self) {[weak self] in
            self?.manager.addStop(stop)
        }
    }
    // MARK: - Private Methods
    
    private func setupMapView() {
        let logo = mapView.mapWindow.map.logo
        let padding = YMKLogoPadding(horizontalPadding: 32, verticalPadding: 32)
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logo.setPaddingWith(padding)
        logo.setAlignmentWith(YMKLogoAlignment(horizontalAlignment: .right, verticalAlignment: .bottom))
    }
    
    private func setupCamera() {
        let map = mapView.mapWindow.map
        let saintPetersburg = YMKPoint(latitude: 59.9343, longitude: 30.3351)
        
        map.move(
            with: YMKCameraPosition(target: saintPetersburg, zoom: 12, azimuth: 0, tilt: 0),
            animation: YMKAnimation(type: .smooth, duration: 1),
            cameraCallback: nil
        )
    }
    
    private func setupUserLocation() {
        let mapKit = YMKMapKit.sharedInstance()
        userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        
        userLocationLayer?.setVisibleWithOn(true)
        userLocationLayer?.isHeadingModeActive = true
        userLocationLayer?.setObjectListenerWith(self)
    }
    
    private func addGeoObjectListener(_ map: YMKMap) {
        map.addTapListener(with: geoObjectTapListener)
    }
    
    private func bindViewModel() {
        manager.addObserver { [weak self] stops in
            DispatchQueue.main.async{
                self?.mapService.refreshPlaceMarks(stops: stops)
            }
        }
    }
}

// MARK: - YMKUserLocationObjectListener

extension MapViewController: YMKUserLocationObjectListener {
    func onObjectAdded(with view: YMKUserLocationView) {}
    
    func onObjectRemoved(with view: YMKUserLocationView) {}
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
}
