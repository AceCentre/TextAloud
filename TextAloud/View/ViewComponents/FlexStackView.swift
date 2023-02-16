//
//  FlexStackView.swift
//  TextAloud
//
//

import SwiftUI

struct FlexibleStackView<T: WordProtocol, Content: View>: View {
    var indexWord: Int = 3
    var inputData: [T]
    var isStaticMode: Bool = false
    var fontWeight: FontWeight = .heavy
    var fontSize: CGFloat = 25
    var spacing: CGFloat = 8
    var alignment: HorizontalAlignment = .leading
    @ViewBuilder let content: (_ index: String) -> Content

    
//    var dinamicData: [(data: [T], id: UUID)] {
//        divideDataIntoLines(lineWidth: getRect().width - 32)
//            .map { (data: $0, id: UUID()) }
//    }
    @State private var staticData: [(data: [T], id: UUID)] = []
    

    var placeholderWigth: CGFloat{
        isStaticMode ? 120 : 180
    }
    
    var body: some View {
    
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(staticData, id: \.id) { data in
                Group {
                    HStack(spacing: spacing) {
                        ForEach(data.data.indices, id: \.self) { index in
                            Text(data.data[index].word)
                                .foregroundColor(indexWord == index ? .red : .white)
                                .font(.system(
                                    size: fontSize,
                                    weight: fontWeight.swiftUIFontWeight)
                                )
                                
                            
                        }
                    }
                }
            }
        }
        .onAppear{
           // if isStaticMode{
                staticData = divideDataIntoLines(lineWidth: getRect().width - 32).map { (data: $0, id: UUID()) }
            //}
        }
    }
    

    private func divideDataIntoLines(lineWidth: CGFloat) -> [[T]] {
        let data = calculateWidths(for: inputData)
        var singleLineWidth = lineWidth
        var allLinesResult = [[T]]()
        var singleLineResult = [T]()
        var partialWidthResult: CGFloat = 0
        data.forEach { (selectableType, width) in
            partialWidthResult = singleLineWidth - width
            if partialWidthResult > 0 {
                singleLineResult.append(selectableType)
                singleLineWidth -= width
            } else {
                allLinesResult.append(singleLineResult)
                singleLineResult = [selectableType]
                singleLineWidth = lineWidth - width
            }
        }
        guard !singleLineResult.isEmpty else { return allLinesResult }
        allLinesResult.append(singleLineResult)
        return allLinesResult
    }
    
    private func calculateWidths(for data: [T]) -> [(value: T, width: CGFloat)] {
        return data.map { selectableType -> (T, CGFloat) in
            let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight.uiFontWeight)
            let textWidth = selectableType.word.getWidth(with: font)
            
            let width = spacing + textWidth
            return (selectableType, width)
        }
    }
}

struct FlexibleStackView_Previews: PreviewProvider {
   static let text = "Ut. Sed et arcu ultricies. Amet, efficitur nec lectus interdum eleifend interdum elit. Dictum vulputate ornare faucibus. Sit vulputate platea elit."
    static let models: [WordModel] = text.components(separatedBy: " ").map({.init(word: $0)})
    static var previews: some View {
        ZStack{
            Color.black
            FlexibleStackView(inputData: models) { str in
//                Text(str)
//                    .foregroundColor(.white)
//                    .background(Color.red)
            }
        }
    }
}


extension FlexibleStackView{
    enum FontWeight {
        case light
        case thin
        case medium
        case regular
        case semibold
        case bold
        case ultralight
        case heavy
        case black
        
        var swiftUIFontWeight: Font.Weight {
            switch self {
            case .light:            return .light
            case .thin:             return .thin
            case .medium:           return .medium
            case .regular:          return .regular
            case .semibold:         return .semibold
            case .bold:             return .bold
            case .ultralight:       return .ultraLight
            case .heavy:            return .heavy
            case .black:            return .black
            }
        }
        
        var uiFontWeight: UIFont.Weight {
            switch self {
            case .light:            return .light
            case .thin:             return .thin
            case .medium:           return .medium
            case .regular:          return .regular
            case .semibold:         return .semibold
            case .bold:             return .bold
            case .ultralight:       return .ultraLight
            case .heavy:            return .heavy
            case .black:            return .black
            }
        }
    }
}



protocol WordProtocol {
    var word: String { get set }
}

struct WordModel: WordProtocol {
    var word: String = ""
}


extension String{
    func getWidth(with font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func getHeight(with font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}
