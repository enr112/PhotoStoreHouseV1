//
//  CircularProgressVC.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 12/11/23.
//

import UIKit

class CircularProgressBar: UIView {

    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    
    var progressColor: UIColor = .blue {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor: UIColor = .lightGray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    var lineWidth: CGFloat = 20.0 {
        didSet {
            progressLayer.lineWidth = lineWidth
            trackLayer.lineWidth = lineWidth
            updateLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupProgressBar()
    }
    
    private func setupProgressBar() {
        createCircularPath()
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }
    
    private func createCircularPath() {
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            radius: (bounds.width - lineWidth) / 2,
            startAngle: -(.pi / 2),
            endAngle: 3 * .pi / 2,
            clockwise: true
        )
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = lineWidth
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeEnd = 0.0
    }
    
    private func updateLayout() {
        createCircularPath()
    }
    
    func setProgress(_ progress: Float) {
        progressLayer.strokeEnd = CGFloat(progress)
    }

}
