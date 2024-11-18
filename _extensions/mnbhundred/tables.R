library(tidyverse)
library(extrafont)

# tables (gt) -------------------------------------------------------------

library(gt)

.gt_finalise <- function(.gt, width = 2000, font_size = 30, ...) {
  
  .gt <- .gt |> 
    tab_options(
      column_labels.background.color = "#364973",
      table_body.hlines.color = "grey80",
      table.border.top.width = px(3),
      table.border.top.color = "black",
      table.border.bottom.color = "black",
      table.border.bottom.width = px(3),
      column_labels.border.top.width = px(3),
      heading.align = "left",
      column_labels.border.top.color = "transparent",
      column_labels.vlines.style = "none",
      column_labels.border.bottom.width = px(3),
      column_labels.border.bottom.color = "transparent",
      row.striping.background_color = "#f9f9fb",
      data_row.padding = px(3),
      table.width = px(width),
      table.font.size = px(font_size),
      heading.title.font.size = px(font_size + 2),
      footnotes.font.size = px(font_size),
      ...
    ) |> 
    cols_align(
      align = "center",
      columns = everything()
    ) |> 
    opt_table_font(
      font = c(
        google_font(name = "Cambria"),
        default_fonts()
      )
    )
  
  cap <- knitr::opts_current$get()$cap
  if (!is.null(cap)) {
    .gt <- .gt |> 
      tab_header(
        title = md(str_c("**", cap, "**"))
      )
  }
  
  comment <- knitr::opts_current$get()$comment
  if (!is.null(comment)) {
    .gt <- .gt |> 
      tab_footnote(
        md(comment),
        placement = "left"
      )
  }
  
  .gt
}

# plots -------------------------------------------------------------------

custom_theme <- theme_minimal(base_family = "Cambria", base_size = 20) + 
  theme(
    axis.title = element_text(size = 20, face = "bold"),
    legend.title = element_text(size = 20, face = "bold"),
    plot.title = ggtext::element_markdown(size = 24, face = "bold", color = "#364973"),
    strip.text = element_text(size = 20, family = "Cambria Medium", face = NULL),
    strip.background = element_rect(fill = "#90d1d5"),
    legend.position = "bottom",
    legend.background = element_blank(),
    plot.title.position = "plot",
    plot.caption = ggtext::element_markdown(size = 16, hjust = 0),
    plot.caption.position = "plot",
  )

theme_set(custom_theme)

# suggested colors for mnb

.co_pal <- tribble(
  ~ hex_code, ~ name,
  "#18223e", "blue",
  "#6fa0be", "blue2", 
  "#f8c567", "yellow",
  "#b2242a", "red",
  "#7aa140", "green",
  "#da3232", "red2",
  "#e57b2b", "orange",
  "#787975", "grey", 
  "#b9e1eb", "blue3"
) |> 
  pull(hex_code, name = name)

.co <- \(x) set_names(.co_pal[x], NULL)

update_geom_defaults("point", list(shape = 21, color = "black", size = 4))
update_geom_defaults("line", list(size = 4, color = .co("blue")))

`-.gg` <<- function(e1, e2) e2(e1)

.gg_finalise <- function(p = ggplot2::last_plot())  {
  cap <- knitr::opts_current$get()$cap
  if (!is.null(cap)) {
    p <- p +
      labs(
        title = cap
      )
  }
  
  comment <- knitr::opts_current$get()$comment
  if (!is.null(comment)) {
    p <- p + 
      labs(
        caption = comment
      )
  }
  
  p
}

