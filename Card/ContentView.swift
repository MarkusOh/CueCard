//
//  ContentView.swift
//  Card
//
//  Created by Seungsub Oh on 3/23/24.
//

import SwiftUI

struct ContentView: View {
    
    
    @State private var data = [
        "1. 다중언어자. 언어 어떻게 빨리?",
        "2. 다중언어자 행사 참여 -> Intro to 베니 -> 200번의 실수",
        "3. 루카스 -> 스카이프. 소리 흉내. 단어 5백개. 문법 먼저.",
        "4. 백백 다 다름 -> 즐김 -> 행복",
        "5. 문법표, 암기 카드, 앱 통계치, 외국어로 된 조리법 -> Engage and improvise",
        "6. 티비쇼 -> 헛소리 -> 23시즌 들리기 시작",
        "7. 노천재. 노지름길. Make it 일과. 앱. 교재. 유튜브 & 팟캐스트. 혼잣말. 하나님과의 영어 대화. 즐기는 것이 좋지만... 그게 노다. 원칙 세가지!",
        "8. 반복. 며칠에 걸쳐",
        "9. 계획. 시간을 찾아라",
        "10. 참을성. 작은 승리 -> transition to 다중언어자는 타고난 거?",
        "11. 베니 학교 16년간 2개국어 실패. but 원어민과 부딪치며 대화해보는 방법. -> 10! \n 루카스. 전교 꼴등. -> 10년만에 11개 국어 -> Transition to 다시 도전!",
        "12. 서서 공부하는 남자",
        "13. 지하철에서 찾은 나의 시간",
        "1. 기본적인 문장. 본문장.",
        "2. 내용 추가. everyday - 세부사항. weekends - 매주말. 세부사항이 표현의 범위.",
        "3. 응용.",
        "4. once in a while. 어쩌다가 한번씩",
        "5. 응용.",
        "6. 응용.",
        "7. 세부사항을 나열해봐! 더 커져! 주어 동사로 구성된 본문장 -> 여기에 세부사항을 더해 더 많은 의미를 추가할 수 있어!",
        "1. 어떤 표현들을 배웠었지? engage",
        "2. everyday · on weekends · in an office · mainly with books · mainly with YouTube videos · by myself · at home · six hours a day. transition to 비동사의 활용으로",
        "3. 일단 배워야 할 것. i - you - he",
        "4. works",
        "5. 본능!",
        "6. he works everyday. she studies at home two hours a day. jane cooks pretty well. he exercies by himself at home two hours a day.",
        "7. I work. -> I don't work on weekends",
        "8. work / study / cook",
        "9. works / studies / cooks / exercises",
        "10. He doesn't work",
        "11. He doesn't work",
        "12. He doesn't work hard. She cooks pretty well. She cooks pretty wel, but she doesn't cook everyday.",
        "13. 연습 시작하세요!",
        "Denn in seinem haus. Ist ein platz für mich. Ich bin Gottes kind. ja sein kind",
    ]
    
    @State private var currentIndex = 0 {
        didSet {
            if currentIndex >= data.count {
                currentIndex = 0
            }
            
            if currentIndex < 0 {
                currentIndex = data.count - 1
            }
        }
    }
    
    var body: some View {
        ScrollViewReader { scrollView in
            GeometryReader { proxy in
                VStack(alignment: .leading) {
                    GeometryReader { proxy in
                        VStack(alignment: .leading) {
                            Text(data[currentIndex])
                                .font(.largeTitle)
                            
                            if currentIndex < data.count - 1 {
                                Text(data[currentIndex + 1])
                                    .font(.body)
                                    .foregroundStyle(Color(uiColor: .label).opacity(0.5))
                            }
                        }
                        .frame(height: proxy.size.height)
                    }
                    .padding()
                    .transaction(value: currentIndex, { transaction in
                        transaction.animation = nil
                    })
                    .overlay {
                        HStack {
                            let pane = GeometryReader(content: {
                                Color.clear
                                    .contentShape(Rectangle())
                                    .frame(width: $0.size.width,
                                           height: $0.size.height)
                            })
                            
                            pane.onTapGesture {
                                withAnimation {
                                    currentIndex -= 1
                                    scrollView.scrollTo(currentIndex)
                                }
                            }
                            pane.onTapGesture {
                                withAnimation {
                                    currentIndex += 1
                                    scrollView.scrollTo(currentIndex)
                                }
                            }
                        }
                    }
                    
                    allCards(scrollView: scrollView)
                }
                .frame(height: proxy.size.height)
            }
            .background(Color(uiColor: .systemBackground))
        }
    }
    
    func allCards(scrollView: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                let width: Double = 800
                let height: Double = 480
                let scale: Double = 0.1
                let selectedScale: Double = 0.15
                let cards: Array<(offset: Int, element: String)> = .init(data.enumerated())
                
                ForEach(cards, id: \.offset) { (index, eachCard) in
                    let scaleForCard = (index == currentIndex ? selectedScale : scale)
                    let scaleSizeForCard: CGSize = .init(width: scaleForCard, height: scaleForCard)
                    
                    Rectangle()
                        .foregroundStyle(Color(uiColor: .systemBackground))
                        .frame(width: width, height: height)
                        .overlay {
                            GeometryReader { proxy in
                                Text(eachCard)
                                    .font(.largeTitle)
                                    .padding(.horizontal)
                                    .frame(height: proxy.size.height)
                            }
                        }
                        .scaleEffect(scaleSizeForCard)
                        .frame(width: width * scaleForCard, height: height * scaleForCard)
                        .border(Color(uiColor: .label), width: 2.5)
                        .overlay(alignment: .bottomTrailing) {
                            Text("\(index + 1)")
                                .padding(.trailing, 5)
                                .padding(.bottom, 1)
                        }
                        .id(index)
                        .onTapGesture {
                            withAnimation {
                                currentIndex = index
                                scrollView.scrollTo(index)
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
