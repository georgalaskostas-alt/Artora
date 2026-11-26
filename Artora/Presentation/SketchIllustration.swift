import SwiftUI

struct SketchIllustration: View {
    let lessonID: String
    let step: Int
    var body: some View {
        Canvas { context, size in
            let scale = min(size.width, size.height) / 240
            var ctx = context
            ctx.translateBy(x: (size.width - 240 * scale)/2, y: (size.height - 240 * scale)/2)
            ctx.scaleBy(x: scale, y: scale)
            let paths = Self.paths(for: lessonID)
            for (index, path) in paths.prefix(max(0, step + 1)).enumerated() {
                ctx.stroke(path, with: .color(index == step ? ArtoraTheme.accent : ArtoraTheme.ink), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
            }
        }
        .accessibilityHidden(true)
    }
    static func paths(for id: String) -> [Path] {
        func line(_ points: [CGPoint], close: Bool = false) -> Path {
            Path { p in p.addLines(points); if close { p.closeSubpath() } }
        }
        func oval(_ x: CGFloat,_ y: CGFloat,_ w: CGFloat,_ h: CGFloat) -> Path {
            Path(ellipseIn: CGRect(x:x,y:y,width:w,height:h))
        }
        switch id {
        case "basic-shapes":
            return [oval(20,70,60,60), Path(CGRect(x:95,y:70,width:60,height:60)), line([CGPoint(x:190,y:70),CGPoint(x:225,y:130),CGPoint(x:160,y:130)],close:true)]
        case "simple-leaf":
            return [
                Path { p in p.move(to: CGPoint(x:65,y:195)); p.addQuadCurve(to: CGPoint(x:175,y:40),control: CGPoint(x:130,y:110)) },
                Path { p in p.move(to: CGPoint(x:65,y:195)); p.addQuadCurve(to: CGPoint(x:175,y:40),control: CGPoint(x:30,y:55)) },
                Path { p in p.move(to: CGPoint(x:175,y:40)); p.addQuadCurve(to: CGPoint(x:65,y:195),control: CGPoint(x:230,y:170)) },
                Path { p in for i in 0..<4 { let t = CGFloat(i)*25; p.move(to: CGPoint(x:85+t*0.65,y:165-t)); p.addLine(to: CGPoint(x:65+t*0.7,y:135-t)); p.move(to: CGPoint(x:85+t*0.65,y:165-t)); p.addLine(to: CGPoint(x:125+t*0.65,y:160-t)) } }
            ]
        case "little-cat":
            return [oval(65,45,110,100),
                Path { p in p.addLines([CGPoint(x:70,y:75),CGPoint(x:70,y:20),CGPoint(x:105,y:48)]); p.move(to: CGPoint(x:135,y:48)); p.addLines([CGPoint(x:170,y:20),CGPoint(x:170,y:75)]) },
                Path { p in p.addEllipse(in:CGRect(x:90,y:85,width:12,height:16)); p.addEllipse(in:CGRect(x:138,y:85,width:12,height:16)); p.addLines([CGPoint(x:113,y:110),CGPoint(x:127,y:110),CGPoint(x:120,y:118),CGPoint(x:113,y:110)]) },
                Path { p in p.move(to: CGPoint(x:85,y:125)); p.addLine(to: CGPoint(x:35,y:115)); p.move(to: CGPoint(x:155,y:125)); p.addLine(to: CGPoint(x:205,y:115)); p.move(to: CGPoint(x:90,y:138)); p.addQuadCurve(to: CGPoint(x:150,y:138),control: CGPoint(x:120,y:300)) }]
        case "coffee-cup":
            return [oval(45,55,130,42), Path { p in p.move(to:CGPoint(x:45,y:76)); p.addLine(to:CGPoint(x:65,y:165)); p.move(to:CGPoint(x:175,y:76)); p.addLine(to:CGPoint(x:155,y:165)) }, Path { p in p.move(to:CGPoint(x:65,y:165)); p.addQuadCurve(to:CGPoint(x:155,y:165),control:CGPoint(x:110,y:195)); p.move(to:CGPoint(x:170,y:95)); p.addQuadCurve(to:CGPoint(x:160,y:145),control:CGPoint(x:240,y:120)) }]
        default: return ExtraIllustrations.paths(for: id)
        }
    }
}
