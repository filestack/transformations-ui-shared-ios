//
//  EditorToolbarItemStyle.swift
//  TransformationsUI
//
//  Created by Ruben Nine on 25/06/2020.
//  Copyright © 2020 Filestack. All rights reserved.
//

import UIKit

public struct EditorToolbarItemStyle {
    /// Defines the default text alignment for the text in this toolbar item.
    public var textAlignment: NSTextAlignment = .natural
    /// Defines the tint color used for this toolbar item.
    public var tintColor: UIColor? = nil
    /// Defines the spacing between the icon and text, if present in this toolbar item.
    public var spacing: CGFloat = 0
    /// Defines the corner radius to apply to the icon.
    public var cornerRadius: CGFloat = 0

    public init(_ build: (inout EditorToolbarItemStyle) -> Void) {
        build(&self)
    }
}
