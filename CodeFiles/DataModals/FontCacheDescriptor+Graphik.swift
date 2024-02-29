extension UIFont {
    
    // The `rawValue` MUST match the filename (without extension)
    public enum OpenSans: String, FontCacheDescriptor {
        case regular = "OpenSans-Regular"
        case bold = "OpenSans-Bold"
        case boldItalic = "OpenSans-BoldItalic"
        case semibold = "OpenSans-Semibold"
        case light = "OpenSans-Light"
        case semiboldItalic = "OpenSans-SemiboldItalic"
        case lightItalic = "OpenSans-LightItalic"
        
    }
    
    /// Makes a new font with the specified variant & size
    public convenience init(openSans: OpenSans, size: CGFloat) {
        self.init(descriptor: openSans, size: size)
    }
    
}
