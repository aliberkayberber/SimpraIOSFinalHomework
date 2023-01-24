//
//  AlertWidget.swift
//  IGDb
//
//  Created by Ali Berkay BERBER on 15.01.2023.
//

import Foundation
import UIKit
extension UIViewController{
    @objc func handleError(_ notification: Notification) {
        if let text = notification.object as? String {
            let alert = UIAlertController(title: NSLocalizedString("ERROR_TITLE", comment: "Error"), message: text, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON", comment: "OK"), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
