import Foundation
import UserNotifications
import CoreLocation

final class NoNotificationManager {
    static let shared = NoNotificationManager()
    
    private var notifiedStops: Set<UUID> = []
    
    private init() {}
    
    func locationManager(for stops: [BusStopItemModel],  userLocations: CLLocation) {
        
        let proximityDistance: Double = 100
        let resetDistance: Double = 120
        
        for stop in stops {
            let stopLocation = CLLocation(latitude: stop.latitude, longitude: stop.longitude)
            let distance = userLocations.distance(from: stopLocation)
            
            if distance <= proximityDistance && !notifiedStops.contains(stop.id)  {
                scheduleProximityNotification(for: stop)
                notifiedStops.insert(stop.id)
            }
            
            if distance > resetDistance && notifiedStops.contains(stop.id) {
                notifiedStops.remove(stop.id)
            }
        }
    }
    
    
    private func scheduleProximityNotification(for stop: BusStopItemModel) {
        let identifier = "proximity-\(stop.id)"
        
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            if notifications.contains(where: {$0.request.identifier == identifier}) {
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = "My Stop"
            content.body = "Вы приближаетесь к остановке: \(stop.street)"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {error in
                if let error = error {
                    print("Ошибка уведомления: \(error)")
                }
            }
        }
    }
}
