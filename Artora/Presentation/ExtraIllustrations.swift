import SwiftUI

enum ExtraIllustrations {
    static func paths(for id: String) -> [Path] {
        func lines(_ groups: [[CGPoint]]) -> Path {
            Path { p in for group in groups { p.addLines(group) } }
        }
        func pts(_ values: [CGFloat]) -> [CGPoint] {
            stride(from: 0, to: values.count, by: 2).map { CGPoint(x: values[$0], y: values[$0+1]) }
        }
        func l(_ groups: [[CGFloat]]) -> Path { lines(groups.map(pts)) }
        func oval(_ x: CGFloat,_ y: CGFloat,_ w: CGFloat,_ h: CGFloat) -> Path { Path(ellipseIn: CGRect(x:x,y:y,width:w,height:h)) }
        switch id {
        case "mountain":
            return [l([[20,175,220,175]]), l([[25,175,85,65,125,130,160,85,215,175]]), Path { p in p.addPath(l([[65,100,85,65,105,100,85,92,65,100],[148,105,160,85,175,110]])); p.addEllipse(in:CGRect(x:180,y:25,width:36,height:36)) }]
        case "fish":
            return [oval(35,75,135,90),l([[165,105,215,75,215,165,165,135]]),Path { p in p.addEllipse(in:CGRect(x:60,y:103,width:10,height:10)); p.move(to:CGPoint(x:90,y:85)); p.addQuadCurve(to:CGPoint(x:90,y:155),control:CGPoint(x:115,y:120)); p.addPath(l([[115,120,145,105,140,135,115,120]])) }]
        case "house":
            return [Path(CGRect(x:65,y:100,width:110,height:110)),l([[50,100,120,35,190,100,50,100]]),Path { p in p.addRect(CGRect(x:105,y:155,width:30,height:55)); p.addRect(CGRect(x:78,y:120,width:24,height:24)) }]
        case "cube":
            return [Path(CGRect(x:45,y:85,width:100,height:100)),l([[45,85,90,40],[145,85,190,40],[145,185,190,140]]),l([[90,40,190,40,190,140]])]
        default: return []
        }
    }
}
