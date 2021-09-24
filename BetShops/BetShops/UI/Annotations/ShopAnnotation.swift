//
//  ShopAnnotation.swift
//  BetShops
//
//  Created by Ivan Ivanušić on 28.08.2021..
//

import MapKit

class ShopAnnotation: MKAnnotationView {
    static let preferredClusteringIdentifier = "ClusterAnnotation"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = ShopAnnotation.preferredClusteringIdentifier
        collisionMode = .circle
        image = UIImage(named: "Asset 54")
        canShowCallout = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var annotation: MKAnnotation? {
        didSet {
            clusteringIdentifier = ShopAnnotation.preferredClusteringIdentifier
            image = UIImage(named: "Asset 54")
            canShowCallout = false
        }
    }
}

