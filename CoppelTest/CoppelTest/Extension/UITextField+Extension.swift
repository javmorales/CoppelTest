//
//  UITextField+Extension.swift
//  CoppelTest
//
//  Created by Javier Morales on 26/10/21.
//

import UIKit

extension UITextField {
    internal func addBottomBorder(height: CGFloat = 1.0, color: UIColor = .gray) {
        let borderView = UIView()
        borderView.backgroundColor = color
        borderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderView)
        NSLayoutConstraint.activate(
            [
                borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
                borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
                borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
                borderView.heightAnchor.constraint(equalToConstant: height)
            ]
        )
    }

}
