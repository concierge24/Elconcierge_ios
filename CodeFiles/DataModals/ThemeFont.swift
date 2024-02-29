//
//  ThemeFont.swift
//  Sneni
//
//  Created by MAc_mini on 30/01/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation

public protocol FontCacheDescriptor: Codable {
    var fontName: String { get }
    var fileName: String { get }
    var fileExtension: String { get }
}

public extension FontCacheDescriptor {
    public var fileExtension: String {
        return "ttf"
    }
}

public extension FontCacheDescriptor where Self: RawRepresentable, Self.RawValue == String {
    public var fontName: String {
        return rawValue
    }
    
    public var fileName: String {
        return rawValue
    }
}

extension UIFont {
    
    
    public convenience init(descriptor: FontCacheDescriptor, size: CGFloat) {
        FontCache.cacheIfNeeded(named: descriptor.fileName, fileExtension: descriptor.fileExtension)
        let size = UIFontMetrics.default.scaledValue(for: size)
        let descriptor = UIFontDescriptor(name: descriptor.fontName, size: size)
        self.init(descriptor: descriptor, size: 0)
    }

}


public class FontCache {
    
    /// iOS already caches the fonts themselves, but doesn't provide a way to query 'already loaded fonts'.
    /// So this cache is just to keep track so we don't load the font more than once.
    static private var cache = [String]()
    
    /// Loads the font and gets iOS to cache it.
    ///
    /// - Parameter name: The name of the font to cache
    public static func cacheIfNeeded(named name: String, fileExtension: String) {
        guard !cache.contains(name) else { return }
        
        guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            fatalError("Could not locate font named: \(name).\(fileExtension)")
        }
        
        do {
            let data = try Data(contentsOf: url)
            guard let provider = CGDataProvider(data: data as CFData),
                let font = CGFont(provider) else {
                    fatalError("Font appears to be corrupt at: \(url)")
            }
            
            var error: Unmanaged<CFError>? = nil
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                if let error: Error = error?.takeRetainedValue() {
                    let nsError = error as NSError
                    // Continue if already registered
                    guard nsError.code == CTFontManagerError.alreadyRegistered.rawValue && nsError.domain == kCTFontManagerErrorDomain as String else {
                        throw error
                    }
                } else {
                    let info = [NSLocalizedDescriptionKey: NSExceptionName.internalInconsistencyException.rawValue]
                    throw NSError(domain: Bundle.main.bundleIdentifier!, code: -1, userInfo: info)
                }
            }
            
            cache.append(name)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
