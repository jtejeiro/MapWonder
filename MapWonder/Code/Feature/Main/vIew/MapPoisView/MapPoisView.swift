//
//  MapPoisView.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 23/2/23.
//

import UIKit
import MapKit
import Kingfisher

protocol MapPoisViewOutput: NSObjectProtocol {
    func mapView(_ mapView: MKMapView, didTapDetailsButton button: UIButton, for annotation: MKAnnotation)
}

class MapPoisView: CalloutView{
    
    private var stadiumImg: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 2
        label.contentMode = .center
        label.font = UIFont(name: "System" , size: 16)
        return label
    }()
    
    weak var delegateOutput: MapPoisViewOutput?

    override init(annotation: MKAnnotation) {
        super.init(annotation: annotation)

        configure()
        updateContents(for: annotation)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Should not call init(coder:)")
    }

    /// Update callout contents

    private func updateContents(for annotation: MKAnnotation) {
        if let model = annotation as? PoisAnnotation {
            titleLabel.text = model.title ?? ""
            setStadiumUrlImageView(urlString: model.urlImg ?? "" )
        }
    }

    /// Add constraints for subviews of `contentView`

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stadiumImg)
        contentView.addSubview(titleLabel)
        //detailsButton.addTarget(self, action: #selector(didTapDetailsButton(_:)), for: .touchUpInside)
        let views: [String: UIView] = [
            "stadiumImg": stadiumImg,
            "titleLabel": titleLabel
        ]


        let vflStrings = [
            "V:|-[stadiumImg]-[titleLabel]-|",
            "H:|-[stadiumImg]-|",
            "H:|-[titleLabel]-|"
        ]

        for vfl in vflStrings {
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vfl, metrics: nil, views: views))
        }
    }

    // This is an example method, defined by `CalloutView`, which is called when you tap on the callout
    // itself (but not one of its subviews that have user interaction enabled).

    override func didTouchUpInCallout(_ sender: Any) {
        print("didTouchUpInCallout")
    }

    /// Callout detail button was tapped
    ///
    /// This is an example action method for tapping the button we added in this subclass.
    /// You'd probably either have a button like this method, or not have a button and use
    /// the above `didTouchUpCallout`, above, but not both. But I'm showing both, so you
    /// can pick whichever you prefer.
    ///
    /// If you want the view controller to do something when you tap on the button, you would:
    ///
    ///  - Want to declare a protocol to which your map view delegate will conform; and
    ///  - Actually see if map view's delegate conforms to this protocol and, if so, call the method.
    ///
    /// - Parameter sender: The button we tapped on in the callout.

    @objc func didTapDetailsButton(_ sender: UIButton) {
        if let mapView = mapView, let delegate = mapView.delegate as? MapPoisViewOutput {
            delegate.mapView(mapView, didTapDetailsButton: sender, for: annotation!)
        }
    }

    /// Map view
    ///
    /// Navigate up view hierarchy until we find `MKMapView`.

    var mapView: MKMapView? {
        var view = superview
        while view != nil {
            if let mapView = view as? MKMapView { return mapView }
            view = view?.superview
        }
        return nil
    }
}

// MARK: Private
private extension MapPoisView {
    
    func setStadiumUrlImageView(urlString:String){
        if let url: URL = URL(string: urlString) {
            self.stadiumImg.kf.setImage(with: url,
                                        placeholder: UIImage(named: "placeholderstadium"),
                                        options: [
                                            .scaleFactor(UIScreen.main.scale),
                                            .transition(.fade(1)),
                                            .cacheOriginalImage
                                        ])
            self.stadiumImg.contentMode = .scaleAspectFill
        }
    }
}

