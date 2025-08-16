import UIKit

final class AlertManager {
    
    static let shared = AlertManager()
    
    private init() {}
    
    func showDeleteConfirmation(on viewController: UIViewController, title: String, handler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Удалить",
                                      style: .default) { _ in
            handler()
        })
        
        alert.addAction(UIAlertAction(title: "Отмена",
                                      style: .default,
                                      handler: nil))
        
        viewController.present(alert, animated: true)
    }
}
