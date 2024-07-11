#let find-paragraph(body) = {
    let res = ()
    let s = ""

    for i in body.children {
        if i.has("text") {
            s += i.text
        }
        if i == parbreak() {
            if (s != "") {
                res.push(s)
            }
            s = ""
        }
    }

    res.push(s)

    return res
}

#let parse-word(sentence) = {
    // not sure how split work with regex
    // sentence.split(regex("(?:\\{.+\\})|\\W"))
    sentence = sentence.split()

    let res = ()
    let left-bracket = 0
    let inside-bracket = false
    let component = ""
    for (idx, val) in sentence.enumerate() {
        if val.contains("{") {
            left-bracket = idx
            let (l, r) = val.split("{")
            if l != "" {
                res.push(l)
            }
            component += r
            inside-bracket = true
        } else if val.contains("}") {
            assert(inside-bracket, message: "Brackets don't match!")
            // FIXME: when "{" and "}" are in the same word and don't match...
            let (l, r) = val.split("}")
            component += " "
            component += l
            res.push(component)
            component = ""
            inside-bracket = false
            if r != "" {
                res.push(r)
            }
        } else if not inside-bracket {
            if val.contains("-") {
                let (l, r) = val.split("-")
                res.push(l)
                res.push("")
                res.push(r)
            } else {
                res.push(val)
            }
        } else {
            component += " "
            component += val
            component += " "
        }
    }

    return res
}

#let align-words(paras) = {
    for i in paras.first().zip(paras.last()) {
        box(height: 20pt, inset: 0.2em)[#align(center)[#i.first() \ #i.last()]]
    }
}

#let replace-paragraph(paras) = {
    paras = paras.map(parse-word)
    align-words(paras)
}

#let bilingural(cont) = {
    let para = find-paragraph(cont)
    para = para.chunks(2)

    for i in para {
        replace-paragraph(i)
        parbreak()
    }
}