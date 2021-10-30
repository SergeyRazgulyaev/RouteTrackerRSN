//
//  Alertable.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 09.04.2021.
//

import UIKit

protocol Alertable {
    func showAttantionAlert(viewController: UIViewController,
                            message: String,
                            handler: ((UIAlertAction) -> ())?,
                            completion: (() -> Void)?)
}

extension Alertable {
    func showAttantionAlert(viewController: UIViewController,
                            message: String,
                            handler: ((UIAlertAction) -> ())? = nil,
                            completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Attention",
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: handler)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: completion)
    }
}
