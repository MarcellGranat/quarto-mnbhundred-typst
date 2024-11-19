#import "_extensions/mnbhundred/exports.typ": *
#import "_extensions/mnbhundred/utils.typ": *
#import "_extensions/mnbhundred/components.typ": *
#import "_extensions/mnbhundred/configs.typ": *
#import "_extensions/mnbhundred/magic.typ"
#import "_extensions/mnbhundred/pdfpc.typ": *
#import "_extensions/mnbhundred/slides.typ": *

#let new-section-slide(level: 1, title)  = touying-slide-wrapper(self => {
  let body = {
    set align(left + horizon)
    set text(size: 2.5em, fill: white, weight: "bold")
    title
  }
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(margin: (left: 2em, top: -0.25em), background: image("_extensions/mnbhundred/blue_bg.png",fit: "stretch", width: 100%,height:100%)),

  ) 
  touying-slide(self: self, body)
})

#let slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  // set page
  let header(self) = {
    set align(top)
    show: components.cell.with(inset: (x: 1em, top: 1.5em))
    set text(
      size: 1.4em,
      fill: white,
      weight: self.store.font-weight-heading,
      font: self.store.font-heading
    )
    utils.call-or-display(self, self.store.header)
    v(1em)
  }
  let footer(self) = {
    set align(bottom)
    show: pad.with(.4em)
    set text(fill: self.colors.neutral-darkest, size: .8em)
    utils.call-or-display(self, self.store.footer)
    h(1fr)
    context utils.slide-counter.display() + " / " + utils.last-slide-number
  }

  // Set the slide
  let self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer,
      background: image("_extensions/mnbhundred/slide_bg.png", fit: "stretch", width: 106%,height:107%),
      margin: (top: 5em)

    ),
  )
  touying-slide(self: self, config: config, repeat: repeat, setting: setting, composer: composer, ..bodies)
})


#let mnbhundred-theme(
  aspect-ratio: "16-9",
  handout: false,
  header: utils.display-current-heading(level: 2),
  footer: [],
  font-size: 20pt,
  font-heading: ("Cambria"),
  font-body: ("Cambria"),
  font-weight-heading: "light",
  font-weight-body: "light",
  font-weight-title: "light",
  font-size-title: 1.4em,
  font-size-subtitle: 1em,
  color-jet: "131516",
  color-accent: "107895",
  color-accent2: "9a2515",
  ..args,
  body,
) = {
  set text(size: font-size, font: font-body, fill: rgb(color-jet),
           weight: font-weight-body)

  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: (top: 4em, bottom: 1.5em, x: 2em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
      handout: handout,
      enable-frozen-states-and-counters: false // https://github.com/touying-typ/touying/issues/72
    ),
    config-methods(
      init: (self: none, body) => {
        show link: set text(fill: self.colors.primary)
        // Unordered List
        set list(
          indent: 1em,
          marker: (text(fill: self.colors.primary)[ #sym.triangle.filled ],
                    text(fill: self.colors.primary)[ #sym.arrow]),
        )
        // Ordered List
        set enum(
          indent: 1em,
          full: true, // necessary to receive all numbers at once, so we can know which level we are at
          numbering: (..nums) => {
            let nums = nums.pos()
            let num = nums.last()
            let level = nums.len()

            // format for current level
            let format = ("1.", "i.", "a.").at(calc.min(2, level - 1))
            let result = numbering(format, num)
            text(fill: self.colors.primary, result)
          }
        ) 
        // Slide Subtitle
        show heading.where(level: 3): title => {
          set text(
            size: 1.1em,
            fill: self.colors.primary,
            font: font-body,
            weight: "light",
            style: "italic",
          )
          block(inset: (top: -0.5em, bottom: 0.25em))[#title]
        }
        set bibliography(title: none, style: "apa")
        body
      },
      alert: (self: none, it) => text(fill: self.colors.secondary, it),
      cover: (self: none, body) => box(scale(x: 0%, body)), // Hack for enum and list
    ),
    config-colors(
      primary: rgb(color-accent),
      secondary: rgb(color-accent2),
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb(color-jet),
    ),
    // save the variables for later use
    config-store(
      header: header,
      footer: footer,
      font-heading: font-heading,
      font-size-title: font-size-title,
      font-size-subtitle: font-size-subtitle,
      font-weight-title: font-weight-title,
      font-weight-heading: font-weight-heading,
      ..args,
    ),
  )

  body
}

#let columns() = {
  set page(columns: 2)
}

#let title-slide(
  ..args,
) = touying-slide-wrapper(self => {
  let info = self.info + args.named()
  let body = {
    set align(center + horizon)
    block(
      inset: (y: 1em, top: 7em),
      [#text(size: self.store.font-size-title,
             fill: white,
             weight: self.store.font-weight-title,
             info.title)
       #if info.subtitle != none {
        linebreak()
        v(-0.3em)
        text(size: self.store.font-size-subtitle,
             style: "italic",
             fill: rgb("#A6A6A6"),
             info.subtitle)
      }]
    )

    set text(fill: white)

    place(
      top + right,
      dx: 15pt,
      if info.authors != none {
        set align(right)
        let count = info.authors.len()
        let ncols = calc.min(count, 3)
        grid(
          columns: (1fr,) * ncols,
          row-gutter: 1.5em,
          ..info.authors.map(author =>
              align(right)[
                #v(1.5em)
                #text(size: 1em, weight: "regular")[#author.name]\
                #text(size: 0.6em)[#author.affiliation]
              ]
          )
        )
      }
    )

    block(text(info.date))
  }
  self = utils.merge-dicts(
    self,
    config-page(margin: (left: 2em, top: -0.25em), background: image("_extensions/mnbhundred/title_slide.png",fit: "stretch", width: 100%,height:100%)),
    config-common(freeze-slide-counter: true)
  )
  touying-slide(self: self, body)
})



// Custom Functions
#let fg = (fill: rgb("9a2515"), it) => text(fill: fill, weight:"bold", it)
#let bg = (fill: rgb("e64173"), it) => highlight(
    fill: fill,
    radius: 2pt,
    extent: 0.2em,
    it
  )
#let _button(self: none, it) = {
  box(inset: 5pt,
      radius: 3pt,
      fill: self.colors.primary)[
    #set text(size: 0.5em, fill: white)
    #sym.triangle.filled.r
    #it
  ]
}

#let button(it) = touying-fn-wrapper(_button.with(it))