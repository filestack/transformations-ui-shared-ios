//
//  ModuleViewController+Setup.swift
//  TransformationsUI
//
//  Created by Ruben Nine on 29/05/2020.
//  Copyright © 2020 Filestack. All rights reserved.
//

import UIKit

extension ModuleViewController {

    func setup() {
        imageView.isOpaque = false
        imageView.contentMode = .redraw

        scrollView.addSubview(imageView)

        canvasView.addSubview(scrollView)
        canvasView.layoutMarginsGuide.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        canvasView.layoutMarginsGuide.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        canvasView.layoutMarginsGuide.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        canvasView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        stackView.addArrangedSubview(canvasView)

        view.fill(with: stackView, activate: true)
    }
}
