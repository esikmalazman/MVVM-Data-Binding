//
//  ThreatsViewModel.swift
//  MVVM
//
//  Created by Ikmal Azman on 13/05/2022.
//  Copyright © 2022 Eric Cerney. All rights reserved.
//

import Foundation

protocol ThreatsViewModelDelegate : AnyObject {
    func didReceiveThreatsData(_ viewModel : ThreatsViewModel)
}

class ThreatsViewModel {
    
    weak var delegate : ThreatsViewModelDelegate?
    var threats = [Threat]() {
        didSet {
            self.delegate?.didReceiveThreatsData(self)
        }
    }
    
    func fetchThreats() {
        SpyService.getNearbyThreats { threats in
            self.threats = threats
  
            dump("Fetched Threats : \n\(threats)")
        }
    }
}

extension ThreatsViewModel {

    func removeThreats() {
        threats.removeAll()
    }
}

extension ThreatsViewModel {
    
    func numberOfThreats() -> Int {
        return threats.count
    }
    
//    func imagePathsForThreatAtIndex(index : Int) -> [String] {
////       print("Test : \( threats[index].imagePaths)")
//        
//       return ["a"]
//    }
    
//    func nameForThreatsAtIndex(index : Int) -> String {
//        let threat = threats[index]
//        return threat.firstName + " " + threat.lastName
//    }
}
