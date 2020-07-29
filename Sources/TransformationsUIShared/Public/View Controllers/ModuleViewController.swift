//
//  ModuleViewController.swift
//  TransformationsUI
//
//  Created by Ruben Nine on 17/12/2019.
//  Copyright © 2019 Filestack. All rights reserved.
//

import UIKit

open class ModuleViewController: ArrangeableViewController {
    // MARK: - Private Properties

    private var observers: [NSKeyValueObservation] = []

    // MARK: - Open Properties

    open weak var discardApplyDelegate: DiscardApplyToolbarDelegate?

    open var zoomEnabled: Bool = true {
        didSet {
            if zoomEnabled {
                recalculateMinAndMaxZoomScales()
                addObservers()
            } else {
                removeObservers()
                scrollView.minimumZoomScale = 1
                scrollView.maximumZoomScale = 1
            }
        }
    }

    open var canScrollAndZoom: Bool = true {
        didSet {
            DispatchQueue.main.async {
                self.scrollView.panGestureRecognizer.isEnabled = self.canScrollAndZoom
                self.scrollView.pinchGestureRecognizer?.isEnabled = self.canScrollAndZoom
            }
        }
    }

    open private(set) lazy var scrollView: CenteredScrollView = {
        let scrollView = CenteredScrollView()

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.clipsToBounds = false

        return scrollView
    }()

    open private(set) lazy var imageView: CIImageView = {
        let imageView = MetalImageView()

        return imageView
    }()

    // MARK: - Public Properties

    public let contentView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false

        return view
    }()

    public let stackView: UIStackView = {
        let stackView = UIStackView()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill

        return stackView
    }()
}

// MARK: - View Overrides

extension ModuleViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let editorModuleVC = self as? EditorModuleVC {
            imageView.image = editorModuleVC.getRenderNode().pipeline?.outputImage
        }

        addObservers()
        recalculateMinAndMaxZoomScales()
        scrollView.zoomScale = scrollView.minimumZoomScale
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeObservers()
    }
}

// MARK: - UIScrollView Delegate

extension ModuleViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

// MARK: - Private Functions

private extension ModuleViewController {
    func addObservers() {
        removeObservers()

        // Typically happens when the device orientation changes.
        observers.append(view.observe(\.bounds, options: [.new, .old]) { (view, change) in
            guard change.newValue?.size != change.oldValue?.size else { return }

            DispatchQueue.main.async {
                self.recalculateMinAndMaxZoomScales()
                self.scrollView.zoomScale = self.scrollView.minimumZoomScale
            }
        })

        // Typically happens when an arranged view from the `stackView` is added, removed, or `isHidden` changes.
        observers.append(contentView.observe(\.bounds, options: [.new, .old]) { (view, change) in
            guard change.newValue?.size != change.oldValue?.size else { return }

            DispatchQueue.main.async { self.recalculateMinAndMaxZoomScales() }
        })

        // Start observing changes in `image` property from `imageView`.
        if let metalImageView = imageView as? MetalImageView {
            observers.append(metalImageView.observe(\.image, options: [.new, .old, .prior]) { imageView, change in
                if change.isPrior {
                    // Notify that imageView's image is about to be updated.
                    (self as? EditorModuleVC)?.willUpdateImageView(imageView: imageView)
                } else {
                    // Notify that imageView's image was just updated.
                    (self as? EditorModuleVC)?.didUpdateImageView(imageView: imageView)

                    // Recalculate scroll view's zoom scale if dimensions changed.
                    if change.oldValue??.extent.size != change.newValue??.extent.size {
                        DispatchQueue.main.async {
                            self.recalculateMinAndMaxZoomScales()
                            self.scrollView.zoomScale = self.scrollView.minimumZoomScale
                        }
                    }
                }
            })
        }
    }

    func removeObservers() {
        observers.removeAll()
    }

    func recalculateMinAndMaxZoomScales() {
        guard zoomEnabled else { return }
        guard let zoomedView = scrollView.delegate?.viewForZooming?(in: scrollView) else { return }
        guard scrollView.bounds.size != .zero && zoomedView.bounds.size != .zero else { return }

        let scaleX = scrollView.bounds.width / zoomedView.bounds.width
        let scaleY = scrollView.bounds.height / zoomedView.bounds.height
        let scale = min(scaleX, scaleY)

        scrollView.minimumZoomScale = scale
        scrollView.maximumZoomScale = .infinity
    }
}
