library(hexSticker)
library(ggplot2)


s <- ggplot() + geom_hexagon(
  size = 1.2, fill = "#1E1E1E",
  color = "#1ABCFE"
) +
  theme_void()


ggsave("inst/figures/baseplot.png", width = 43.9,
              height = 50.8, units = "mm", dpi = 300)
