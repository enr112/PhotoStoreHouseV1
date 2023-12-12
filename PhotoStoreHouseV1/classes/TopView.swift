//
//  TopView.swift
//  PhotoStoreHouseV1
//
//  Created by Loaner on 12/12/23.
//

import UIKit

class TopView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // Create UIImageView and UIButton
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false // Enables manual layout constraints
        // Set the image for the imageView
        imageView.image = UIImage(named: "user29x29.png")
        // Set the size of the image (adjust these values as needed)
        //imageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        return imageView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        Utilities.styleFilledButton(button)
        button.setTitle("My Account", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false // Enables manual layout constraints
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        // Add an action to the button
        button.addTarget(TopView.self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    // Action for the button
    @objc private func buttonTapped() {
        print("Button tapped!")
        // Add your custom action here
    }

    // Initializer for TopView
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // Function to set up the views and layout constraints
    private func setupViews() {
        // Add the imageView and button to the stackView
        let stackView = UIStackView(arrangedSubviews: [imageView, button])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false // Enables manual layout constraints
        
        // Add the stackView to the TopView
        addSubview(stackView)
        // Calculate the quarter of the screen width
        let aThirdScreenWidth = UIScreen.main.bounds.width / 3.0
        
        // Set up layout constraints for the stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            //stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.widthAnchor.constraint(equalToConstant: aThirdScreenWidth),
            //stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
            //stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
}
