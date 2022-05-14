import Foundation

func dispatchAfter(seconds: Double, block: @escaping () -> Void) {
    let when = DispatchTime.now() + seconds
    DispatchQueue.main.asyncAfter(deadline: when, execute: block)
}


