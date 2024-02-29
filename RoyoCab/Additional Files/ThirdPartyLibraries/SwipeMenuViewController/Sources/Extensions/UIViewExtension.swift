import UIKit

extension UIView {

    var hasSafeAreaInsets: Bool {
        guard #available (iOS 11, *) else { return false }
        return safeAreaInsets != .zero
    }
    
    func addBorderGradient(firstColor:UIColor,secondColor:UIColor){
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(rect: self.bounds).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.cornerRadius = 4
        gradient.mask = shape
        
        self.layer.addSublayer(gradient)
        
    }
    
    func addShadowWithCornerRadius(frame:CGRect? = nil,cornerRadius:CGFloat,shadowOffset:CGSize = .zero,shadowColor:CGColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:0.11).cgColor,shadowRadius:CGFloat = 8,shadowOpacity:Float = 1.0){
        
        let layer = UIView(frame: frame ?? self.bounds)
        layer.layer.cornerRadius = cornerRadius
        layer.backgroundColor = UIColor.white
        layer.layer.shadowOffset = shadowOffset
        layer.layer.shadowColor = shadowColor
        layer.layer.shadowOpacity = shadowOpacity
        layer.layer.shadowRadius = shadowRadius
        layer.isUserInteractionEnabled = false
        self.insertSubview(layer, at: 0)
    }
    
    
}

class DashedLineView: UIView {

     @IBInspectable public var strokeColor: CGColor = UIColor.gray.cgColor
     @IBInspectable public var cornerRadius:CGFloat = 4.0
    
    private let borderLayer = CAShapeLayer()

    override func awakeFromNib() {

        super.awakeFromNib()

        borderLayer.strokeColor = strokeColor
        borderLayer.lineDashPattern = [4,4]
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 1.0
        borderLayer.fillColor = UIColor.clear.cgColor

        layer.addSublayer(borderLayer)
    }

    override func draw(_ rect: CGRect) {

        borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
    }
}

class RoundShadowButton: UIButton {
    
//    @IBInspectable public var shadowColor:UIColor = UIColor.AppShadowLightGray
//    @IBInspectable public var shadowOffset:CGSize = CGSize.zero
//    @IBInspectable public var shadowRadius:CGFloat = 8.0
//    @IBInspectable public var shadowOpacity:Float = 0.2
    @IBInspectable public var cornerRadius:CGFloat = 8.0
    private var shadowLayer: CAShapeLayer!
//    private var cornerRadius: CGFloat = 25.0
    private var fillColor: UIColor = .white // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = shadowColor?.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = shadowOffset
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowRadius = shadowRadius
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

class RoundShadowView: UIView {
    
//    @IBInspectable public var shadowColor:UIColor = UIColor.black
//    @IBInspectable public var shadowOffset:CGSize = CGSize.zero
//    @IBInspectable public var shadowRadius:CGFloat = 8.0
//    @IBInspectable public var shadowOpacity:Float = 0.2
    @IBInspectable public var cornerRadius:CGFloat = 8.0
    
    private var shadowLayer: CAShapeLayer!
    private var fillColor: UIColor = .blue // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = shadowColor?.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = shadowOffset
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowRadius = shadowRadius
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
}

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        gradient.colors = [firstColor, secondColor].map {$0.cgColor}
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1.21, y: -0.23)
        gradient.endPoint = CGPoint(x: -0.25, y: 1.23)
        
       // layer.layer.addSublayer(gradient)
        
       /* let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map {$0.cgColor}
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 1.21, y: -0.23) //CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: -0.25, y: 1.23) //CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 1.21, y: -0.23) //CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint(x: -0.25, y: 1.23) // CGPoint (x: 0.5, y: 1)
        } */
    }
    
}


@IBDesignable
class GradientButton: UIButton {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map {$0.cgColor}
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
    
}
