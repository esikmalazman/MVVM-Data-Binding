import Foundation

struct SpyService {
    static func getNearbyThreats(completion: @escaping([Threat]) -> ()) {
        DispatchQueue.global(qos: .background).async {
            sleep(1)
  
            let threats = [
                Threat(firstName: "Ray",
                       lastName: "Wenderlich",
                       imagePaths: ["Dog1","Dog2","Dog3"]),
                
                Threat(firstName: "Greg",
                       lastName: "Heo",
                       imagePaths: ["Cat1","Cat2","Cat3", "Cat4"]),
            ]
                
            
            DispatchQueue.main.async {
                completion(threats)
            }
        }
    }
}
