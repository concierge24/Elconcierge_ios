

import Foundation
import Alamofire
import SwiftyJSON

protocol RouterCab {
    var route : String { get }
    var baseURL : String { get }
    var parameters : OptionalDictionary { get }
 //   var headers : OptionalDictionary { get }
    var method : Alamofire.HTTPMethod { get }
    func handle(parameters : JSON) -> Any?
    func request( isImage: Bool  , images: [ UIImage? ]? , isLoaderNeeded : Bool? , header: [String: String] , completion : @escaping CompletionCab)
}

extension Sequence where Iterator.Element == Keys {
    func map(values: [Any?]) -> [String : Any]? {
        var params = [String : Any]()
        for (index,element) in zip(self,values) {
            if let element = element {
                params[index.rawValue] = element
            }
        }
        return params
    }
}

//swiftgen storyboards -t swift3 "$PROJECT_DIR" --output "$PROJECT_DIR/NequoreUser/Constant/StoryBoardConstant.swift"
