//
//  SegmentedControlToolbar.swift
//  TransformationsUI
//
//  Created by Ruben Nine on 28/05/2020.
//  Copyright © 2020 Filestack. All rights reserved.
//

import UIKit

/// `SegmentedControlToolbar` is a special type of `StandardToolbar` that presents items inside a `UISegmentedControl`.
public class SegmentedControlToolbar: StandardToolbar {
    // MARK: - Private Properties

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: descriptibleItems.enumerated().compactMap { $0.element.title })

        control.addTarget(self, action: #selector(segmentedToolbarItemSelected), for: .valueChanged)
        control.selectedSegmentIndex = 0

        // Prefer images over text, if available.
        for (idx, item) in descriptibleItems.enumerated() {
            guard let image = item.icon else { continue }

            image.accessibilityLabel = item.title

            control.setImage(image, forSegmentAt: idx)
        }

        return control
    }()

    // MARK: - Lifecycle

    public required init(items: [DescriptibleEditorItem], style: EditorToolbarStyle = .segments) {
        super.init(items: items, style: style)

        setItems([segmentedControl])
    }

    public required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions

private extension SegmentedControlToolbar {
    @objc func segmentedToolbarItemSelected(sender: UIControl) {
        selectedItem = segmentedControl
        let item = descriptibleItems[segmentedControl.selectedSegmentIndex]

        delegate?.toolbarItemSelected(toolbar: self,
                                      item: item,
                                      control: segmentedControl)
    }
}

// MARK: - Public Functions

public extension SegmentedControlToolbar {
    func resetSelectedSegment(to index: Int = 0) {
        segmentedControl.selectedSegmentIndex = index
    }
}
