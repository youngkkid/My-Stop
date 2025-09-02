import YandexMapsMobile

// MARK: - BusStopViewModel
final class BusStopViewModel: BusStopManaging {
    
    // MARK: - Properties
    
    private(set) var stops: [BusStopItemModel] = [] {
        didSet {
            notifyObservers()
            saveStops()
        }
    }
    
    private var stopObservers: [(([BusStopItemModel]) -> Void)] = []
    
    // MARK: - Init
    
    init() {
        loadStops()
    }
    
    // MARK: - Public Methods
    
    func addStop(_ stop: BusStopItemModel) {
        stops.append(stop)
    }
    
    func removeStop(_ stop: BusStopItemModel) {
        stops.removeAll { $0.id == stop.id }
    }
    
    func selectedGeoObject(_ geoObject: YMKGeoObject) -> BusStopItemModel {
        let name = geoObject.name ?? "Неизвестная остановка"
        let latitude = geoObject.geometry.first?.point?.latitude ?? 0
        let longitude = geoObject.geometry.first?.point?.longitude ?? 0
        return BusStopItemModel(street: name, latitude: latitude, longitude: longitude)
    }
    
    func addObserver(_ observer: @escaping ([BusStopItemModel]) -> Void) {
        stopObservers.append(observer)
        observer(stops)
    }
    
    internal func notifyObservers() {
        stopObservers.forEach { $0(stops) }
    }
    
    // MARK: - Private Methods
    
    private func saveStops() {
        guard let data = try? JSONEncoder().encode(stops) else { return }
        UserDefaults.standard.set(data, forKey: "savedStops")
    }
    
    private func loadStops() {
        guard let data = UserDefaults.standard.data(forKey: "savedStops"),
              let savedStops = try? JSONDecoder().decode([BusStopItemModel].self, from: data) else {
            stops = []
            return
        }
        stops = savedStops
    }
    
}

