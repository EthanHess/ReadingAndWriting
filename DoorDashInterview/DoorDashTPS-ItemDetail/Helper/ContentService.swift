import Foundation
import Combine
import UIKit

//For Main VC (ViewController)
struct ContentService {
    /// fetches data for the content of the list
    func getItemData() {
        let path = Bundle.main.path(forResource: "Content", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)

        //TODO: Instead of just printing a string, deserialize into objects and inform view controller
        print(try! JSONSerialization.jsonObject(with: data, options: .allowFragments))
    }
    
    //MARK: Standard fetching
    static func fetchJSONData(_ path: String, completion: @escaping((_ feedModels: [String: Any]?, _ theError: Error?) -> Void)) {
        
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        
        print("JSON DATA \(try! JSONSerialization.jsonObject(with: data, options: .allowFragments))")
        
        do {
            let serializedJSON = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            completion(serializedJSON, nil)
        } catch let tError {
            completion(nil, tError)
        }
    }
    
    //MARK: Codable
    static func fetchCodableJSONData(_ path: String, completion: @escaping((_ feedModels: FeedDictionary?, _ theError: Error?) -> Void)) {
        let url = URL(fileURLWithPath: path)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if (error != nil) {
                completion(nil, error)
            } else {
                
            guard let data = data else { return }
                do {
                let feedModels = try JSONDecoder().decode(FeedDictionary.self, from: data)
                    print("\(feedModels)")
                    completion(feedModels, nil)
                } catch let JSONError {
                    print("--- JSON Error --- \(JSONError)")
                    completion(nil, JSONError)
                }
                }
            }.resume()
    }
    
    //MARK: Combine (Publishers)
    @available(iOS 13.0, *)
    static func fetchDataCombine(_ path: String) -> AnyPublisher<FeedDictionary, Error> {
        let url = URL(fileURLWithPath: path)
        
        return URLSession.shared.dataTaskPublisher(for: url).map {
            $0.data
        }.decode(type: FeedDictionary.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        //.eraseToAnyPublisher erases the type of upstream publisher
        
        //From IBM docs
        
        //An upstream system is any system that sends data to the Collaboration Server system. A downstream system is a system that receives data from the Collaboration Server system. ... An upstream system can be any system that publishes item information to the Collaboration Server system
    }
    
    //MARK: Async Await
    @available(iOS 13.0.0, *)
    static func fetchDataAsyncAwait(_ path: String) async throws -> FeedDictionary? {
        let url = URL(fileURLWithPath: path)
        do {
            if #available(iOS 15.0, *) {
                let (data, _) = try await URLSession.shared.data(from: url)
                let dict = try JSONDecoder().decode(FeedDictionary.self, from: data)
                    return dict
            } else {
                // Fallback on earlier versions
                return nil
            }
            
        } catch {
            return nil
        }
    }
}


struct FeedDictionary : Codable {
    
    var content_items : [ContentItem] = []
    var header_image_url : String = ""
    
    enum CodingKeys: String, CodingKey {
        case content_items
        case header_image_url
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        header_image_url = try values.decodeIfPresent(String.self, forKey: .header_image_url) ?? ""
        content_items = try values.decodeIfPresent([ContentItem].self, forKey: .content_items) ?? []
    }
}

struct ContentItem : Codable {
    
    var content : String = ""
    var image_url : String = ""
    var title : String = ""
    
    enum CodingKeys: String, CodingKey {
        case content
        case image_url
        case title
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        content = try values.decodeIfPresent(String.self, forKey: .content) ?? ""
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
    }
}

