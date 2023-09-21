//
//  CarouselLayout.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/20.
//

import UIKit

final class CarouselLayout: UICollectionViewFlowLayout {
    var sideItemScale: CGFloat = 0.5
    var sideItemAlpha: CGFloat = 0.5
    var spacing: CGFloat = 10
    var sideItemCount: Int = 2
    
    private var isSetup: Bool = false
    private(set) var centerIndexPath: IndexPath?
    
    init(scrollDirection: UICollectionView.ScrollDirection) {
        super.init()
        CarouselSetting.shared.scrollDirection = scrollDirection
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        if isSetup == false {
            setupLayout()
            isSetup = true
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes],
              let collectionView
        else { return nil }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visibleCenter = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let center = visibleCenter.xDepends + visibleCenter.yDepends
        
        for layoutAttributes in attributes {
            let itemCenter = layoutAttributes.centerDepends
            if (itemCenter - center).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemCenter - center
                centerIndexPath = layoutAttributes.indexPath
            }
        }
        
        return attributes.map { transformLayoutAttributes(attributes: $0) }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView else {
            let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            return latestOffset
        }
        
        let targetRect = CGRect(x: proposedContentOffset.xDepends, y: proposedContentOffset.yDepends, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let center = (proposedContentOffset.xDepends + proposedContentOffset.yDepends) + collectionView.centerDepends
        
        for layoutAttributes in rectAttributes {
            let itemCenter = layoutAttributes.centerDepends
            if (itemCenter - center).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemCenter - center
            }
        }
        
        switch CarouselSetting.shared.scrollDirection {
        case .vertical:
            return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + offsetAdjustment)
        case .horizontal:
            return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
        @unknown default:
            fatalError()
        }
    }
    
    private func setupLayout() {
        guard let collectionViewSize = collectionView?.bounds.size else { return }
        
        let xInset = (collectionViewSize.width - itemSize.width) / 2
        let yInset = (collectionViewSize.height - itemSize.height) / 2
        
        sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let scaledItemOffset = (itemSizeDepends - itemSizeDepends * sideItemScale) / 2
        
        minimumLineSpacing = spacing - scaledItemOffset
        
        scrollDirection = CarouselSetting.shared.scrollDirection
    }
    
    private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView else { return attributes }
        
        let collectionCenter = collectionView.centerDepends
        let contentOffset = collectionView.contentOffsetDepends
        let center = attributes.centerDepends - contentOffset
        
        let maxDistance = (itemSizeDepends + minimumLineSpacing) * 2
        let distance = min(abs(collectionCenter - center), maxDistance)
        
        let ratio = (maxDistance - distance) / maxDistance
        
        let alpha = ratio * (1 - sideItemAlpha) + sideItemAlpha
        let scale = ratio * (1 - sideItemScale) + sideItemScale
        
        attributes.alpha = alpha
        
        if let centerIndexPath, abs(centerIndexPath.item - attributes.indexPath.item) > sideItemCount {
            attributes.alpha = 0
        }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let dist = attributes.frame.midDepends - visibleRect.midDepends
        var transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        transform = CATransform3DTranslate(transform, 0, 0, -abs(dist / 1000))
        attributes.transform3D = transform
        
        return attributes
    }
}

fileprivate final class CarouselSetting {
    static let shared = CarouselSetting()
    
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
}

fileprivate extension CarouselLayout {
    var itemSizeDepends: CGFloat {
        switch CarouselSetting.shared.scrollDirection {
        case .vertical:
            return itemSize.height
        case .horizontal:
            return itemSize.width
        @unknown default:
            fatalError()
        }
    }
}

fileprivate extension UICollectionView {
    var centerDepends: CGFloat {
        switch CarouselSetting.shared.scrollDirection {
        case .vertical:
            return frame.size.height / 2
        case .horizontal:
            return frame.size.width / 2
        @unknown default:
            fatalError()
        }
    }
    
    var contentOffsetDepends: CGFloat {
        switch CarouselSetting.shared.scrollDirection {
        case .vertical:
            return contentOffset.y
        case .horizontal:
            return contentOffset.x
        @unknown default:
            fatalError()
        }
    }
}

fileprivate extension CGPoint {
    var xDepends: CGFloat {
        switch CarouselSetting.shared.scrollDirection {
        case .vertical:
            return 0
        case .horizontal:
            return x
        @unknown default:
            fatalError()
        }
    }
    
    var yDepends: CGFloat {
        switch CarouselSetting.shared.scrollDirection {
        case .vertical:
            return y
        case .horizontal:
            return 0
        @unknown default:
            fatalError()
        }
    }
}

fileprivate extension CGRect {
    var midDepends: CGFloat {
        switch CarouselSetting.shared.scrollDirection {
        case .vertical:
            return midY
        case .horizontal:
            return midX
        @unknown default:
            fatalError()
        }
    }
}

fileprivate extension UICollectionViewLayoutAttributes {
    var centerDepends: CGFloat {
        switch CarouselSetting.shared.scrollDirection {
        case .vertical:
            return center.y
        case .horizontal:
            return center.x
        @unknown default:
            fatalError()
        }
    }
}
