//
//  RequestComp.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/13.
//
import SwiftUI

struct RequestComp: View {
    @StateObject private var requestsModel = RequestModel()
    var body: some View {
        VStack{
            ForEach(requestsModel.requests){ i in
                RequestCard(iconImage: i.iconImage, name: i.name)
                
            }
        }
        .frame(width: 300)
        .padding(.top, 10)

    }
}
#Preview {
    RequestComp()
}
