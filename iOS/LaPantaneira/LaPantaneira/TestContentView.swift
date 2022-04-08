
import SwiftUI

struct TestContentView: View {
    let url = URL(string: "br.gov.caixa.fgm://")!
    
    var body: some View {
        VStack {
            DSButton(title: "Open") {
                if !UIApplication.shared.openURL(url) {
                    guard let url = URL(string: "https://apps.apple.com/br/app/fgts/id1038441027?l=en") else { return
                    }
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
