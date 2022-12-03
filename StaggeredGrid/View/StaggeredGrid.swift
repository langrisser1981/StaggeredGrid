//
//  StaggeredGrid.swift
//  StaggeredGrid
//
//  Created by 程信傑 on 2022/7/9.
//

import SwiftUI

struct StaggeredGrid<Content: View, T: Identifiable>: View where T: Hashable {
    var columns: Int // 決定顯示幾排直列，主要的動畫參數
    var list: [T] = [] // 要顯示的資料陣列，須符合泛型T
    var content: (T) -> Content // 由外部定義的閉包，根據T建立一個view
    var showIndicators: Bool
    var spacing: CGFloat // 直列中各個view的間距
    
    @Namespace var animation
    
    init(columns: Int, list: [T], @ViewBuilder content: @escaping (T) -> Content, showIndicators: Bool = false, spacing: CGFloat = 10) {
        self.columns = columns
        self.list = list
        self.content = content
        self.showIndicators = showIndicators
        self.spacing = spacing
    }
    
    // 將原本的一維資料陣列，根據要顯示的行數，轉換為二維矩陣
    func setupList() -> [[T]] {
        // 根據要顯示的行數，建立一個空二維矩陣
        var gridArray: [[T]] = Array(repeating: [], count: columns)
        
        var currentIndex = 0
        // 將資料內的物件依序放入矩陣
        // 原陣列: [1,2,3,4,5,6,7,8,9,10]
        // 如果要顯示的行數為3
        // 新陣列: [[1,4,7,10], [2,5,8], [3,6,9]]
        for object in list {
            gridArray[currentIndex].append(object)
            
            if currentIndex < columns - 1 {
                currentIndex += 1
            } else {
                currentIndex = 0
            }
        }
        
        return gridArray
    }
    
    var body: some View {
        // 將所有的元件放在一個scroll view
        ScrollView(.vertical, showsIndicators: showIndicators) {
            // 將原始陣列轉換為二維陣列後，將一維資料對應橫排
            HStack(alignment: .top) {
                ForEach(setupList(), id: \.self) { columnData in
                    
                    // 二維資料對應直排
                    LazyVStack(spacing: spacing) {
                        // 將資料(T)傳入，作為閉包content的參數，建立顯示的元件
                        // 同時套用matchedGeometryEffect做出行數改變時，元件位移的動態效果
                        ForEach(columnData) { object in
                            content(object)
                                .matchedGeometryEffect(id: object.id, in: animation)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .animation(.easeInOut, value: columns) // 設定行數為動畫因子
    }
}

struct StaggeredGrid_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
