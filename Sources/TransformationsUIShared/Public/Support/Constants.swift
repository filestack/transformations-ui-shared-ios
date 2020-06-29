//
//  Constants.swift
//  TransformationsUI
//
//  Created by Ruben Nine on 11/11/2019.
//  Copyright © 2019 Filestack. All rights reserved.
//

import UIKit

public struct Constants {
    public struct Size {}
    public struct Spacing {}
    public struct Color {}
    public struct Margin {}
    public struct Misc {}
    public struct Animations {}
}

extension Constants.Size {
    public static let defaultToolbarHeight: CGFloat = 60
    public static let mediumToolbarHeight: CGFloat = 70
    public static let largeToolbarHeight: CGFloat = 80

    public static let toolbarItem = CGSize(width: 60, height: 60)
    public static let wideToolbarItem = CGSize(width: 80, height: 60)
    public static let toolbarIcon = CGSize(width: 44, height: 44)
}

extension Constants.Spacing {
    public static let toolbarItem: CGFloat = 6
    public static let toolbarInset: CGFloat = toolbarItem * 2
    public static let insetContentLayout = NSDirectionalEdgeInsets(top: 5, leading: 40, bottom: 5, trailing: 40)
}

extension Constants.Color {
    public static let background = UIColor.fromFrameworkBundle("background")
    public static let moduleBackground = UIColor.fromFrameworkBundle("moduleBackground")
    public static let innerToolbar = UIColor.fromFrameworkBundle("innerToolbar")
    public static let defaultTint = UIColor.fromFrameworkBundle("defaultTint")
    public static let primaryActionTint = UIColor.fromFrameworkBundle("primaryActionTint")
}

extension Constants.Misc {
    public static let cropHandleRadius: CGFloat = 9
    public static let cropLineThickness: CGFloat = 3
    public static let cropOutsideOpacity: Float = 0.7
}

extension Constants.Animations {
    public static func `default`(_ block: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 1,
            options: [.curveEaseInOut],
            animations: { block() },
            completion: nil
        )
    }
}
