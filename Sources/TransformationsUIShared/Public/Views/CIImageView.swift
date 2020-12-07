//
//  CIImageView.swift
//  TransformationsUI
//
//  Created by Ruben Nine on 22/10/2019.
//  Copyright © 2019 Filestack. All rights reserved.
//

import UIKit
import MetalKit
import CoreImage

public class CIImageView: MTKView {
    // MARK: - Public Properties

    @objc public dynamic var image: CIImage? {
        didSet {
            guard let image = image else { return }

            bounds = CGRect(origin: .zero, size: image.extent.size)
            frame = CGRect(origin: .zero, size: frame.size)

            setNeedsDisplay()
        }
    }

    // MARK: - Private Properties

    private let colorSpace = CGColorSpaceCreateDeviceRGB()

    private lazy var commandQueue: MTLCommandQueue? = {
        return device!.makeCommandQueue()
    }()

    private lazy var ciContext: CIContext = {
        if #available(iOS 13.0, *) {
            return CIContext(mtlCommandQueue: commandQueue!)
        } else {
            return CIContext(mtlDevice: device!)
        }
    }()

    // MARK: - Lifecycle

    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device ?? MTLCreateSystemDefaultDevice())

        guard super.device != nil else {
            fatalError("Device doesn't support Metal")
        }

        isPaused = true
        enableSetNeedsDisplay = true
        framebufferOnly = false
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Draw Overrides

    public override func draw(_ rect: CGRect) {
        guard let image = image, let currentDrawable = currentDrawable else { return }
        guard drawableSize.width > 0, drawableSize.height > 0 else { return }
        guard let commandBuffer = commandQueue?.makeCommandBuffer() else { return }

        let scaleX = drawableSize.width / image.extent.width
        let scaleY = drawableSize.height / image.extent.height
        let scale = min(scaleX, scaleY)

        // Scaled image
        let scaled = image
            .transformed(by: CGAffineTransform(scaleX: scale, y: scale))

        // Centered scaled image
        let centered = scaled
            .transformed(by: CGAffineTransform(translationX: (drawableSize.width - scaled.extent.width) / 2,
                                               y: (drawableSize.height - scaled.extent.height) / 2))
            .transformed(by: CGAffineTransform(translationX: -scaled.extent.origin.x,
                                               y: -scaled.extent.origin.y))

        let destination = CIRenderDestination(width: Int(drawableSize.width),
            height: Int(drawableSize.height),
            pixelFormat: colorPixelFormat,
            commandBuffer: commandBuffer,
            mtlTextureProvider: { currentDrawable.texture }
        )

        do {
            try ciContext.startTask(toClear: destination)
            try ciContext.startTask(toRender: centered, to: destination)

            #if targetEnvironment(simulator)
            commandBuffer.present(currentDrawable)
            #else
            commandBuffer.present(currentDrawable, afterMinimumDuration: 1 / CFTimeInterval(preferredFramesPerSecond))
            #endif

            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
        } catch {
            print("ERROR: Unable to render image in CoreImage context: \(error.localizedDescription)")
        }
    }
}
