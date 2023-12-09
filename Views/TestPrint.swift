//
//  TestPrint.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 05/12/2023.
//

import SwiftUI

struct TestPrint: View {
    var body: some View {
        Text("lkkkkk")
            .onTapGesture {
                print("f")
            }
    }
}

struct TestPrint_Previews: PreviewProvider {
    static var previews: some View {
        TestPrint()
    }
}
