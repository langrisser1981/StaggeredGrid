//
//  Home.swift
//  StaggeredGrid
//
//  Created by 程信傑 on 2022/7/9.
//

import SwiftUI

struct Home: View {
    @State var posts: [Post] = []
    @State var columns = 2 // 行數，決定排版與觸發動畫

    var body: some View {
        NavigationStack {
            // MARK: 核心物件，根據行數排版，並在改變時產生動態效果

            StaggeredGrid(columns: columns, list: posts) { post in
                PostCardView(post: post)
                    .onAppear {
                        print(post.imageURL)
                    }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // 增加一行，最多不超過五行
                    Button {
                        columns = min(columns + 1, 5)
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    // 減少一行，最少為一行
                    Button {
                        columns = max(columns - 1, 1)
                    } label: {
                        Image(systemName: "minus")
                    }
                }
            }
            .navigationTitle("Staggered Grid")
        }
        .onAppear {
            // 啟動後建立十筆post資料，放到posts陣列
            for index in 1 ... 10 {
                posts.append(Post(imageURL: "post\(index)"))
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: 用作顯示的卡片

// 接收一個post型別，根據其imageURL參數，讀取asset中的圖片
struct PostCardView: View {
    var post: Post

    var body: some View {
        Image(post.imageURL)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
    }
}
