import UIKit

extension UIView {

    public enum PinSide: Int {
        case top, bottom, left, right
    }
    
    func pin(to superview: UIView, _ sides: [PinSide]) {
        for side in sides {
            switch side {
            case .top:
                pinTop(to: superview)
            case .bottom:
                pinBottom(to: superview)
            case .left:
                pinLeft(to: superview)
            case .right:
                pinRight(to: superview)
            }
        }
    }
    
    func pin(to superview: UIView, _ sides: [PinSide: Int]) {
            for side in sides {
                switch side.key {
                case .top:
                    pinTop(to: superview, side.value)
                case .bottom:
                    pinBottom(to: superview, side.value)
                case .left:
                    pinLeft(to: superview, side.value)
                case .right:
                    pinRight(to: superview, side.value)
                }
            }
        }
    
    func pin(to superview: UIView, _ sides: [PinSide], _ const: Int = 0) {
        for side in sides {
            switch side {
            case .top:
                pinTop(to: superview, const)
            case .bottom:
                pinBottom(to: superview, const)
            case .left:
                pinLeft(to: superview, const)
            case .right:
                pinRight(to: superview, const)
            }
        }
    }

    func pin(to superview: UIView, _ sides: PinSide...) {
        translatesAutoresizingMaskIntoConstraints = false
        for side in sides {
            switch side {
            case .top:
                pinTop(to: superview)
            case .left:
                pinLeft(to: superview)
            case .right:
                pinRight(to: superview)
            case .bottom:
                pinBottom(to: superview)
            }
        }
    }

    func pin(to superview: UIView) {
        pinTop(to: superview)
        pinLeft(to: superview)
        pinRight(to: superview)
        pinBottom(to: superview)
    }

    @discardableResult
    func pinTop(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(
            equalTo: superview.topAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func pinTop(to side: NSLayoutYAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func pinBottom(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(
            equalTo: superview.bottomAnchor,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func pinBottom(to side: NSLayoutYAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func pinLeft(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(
            equalTo: superview.leadingAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func pinLeft(to side: NSLayoutXAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func pinRight(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(
            equalTo: superview.trailingAnchor,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func pinRight(to side: NSLayoutXAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func setHeight(to const: Int) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func setHeight(to const: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func setWidth(to const: Int) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func setWidth(to const: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func pinCenterX(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(
            equalTo: superview.centerXAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func pinCenterX(to center: NSLayoutXAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(
            equalTo: center,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func pinCenterY(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(
            equalTo: superview.centerYAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func pinCenterY(to center: NSLayoutYAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(
            equalTo: center,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }

    func pinCenter(to superview: UIView) {
        pinCenterX(to: superview)
        pinCenterY(to: superview)
    }
}
