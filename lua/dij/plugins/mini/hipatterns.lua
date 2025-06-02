local hipatterns = require("mini.hipatterns")
hipatterns.setup({
  highlighters = {
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
    bug = { pattern = "%f[%w]()BUG()%f[%W]", group = "MiniHipatternsFixme" },
    conflict = { pattern = "%f[%w]()CONFLICT()%f[%W]", group = "MiniHipatternsFixme" },
    tempfix = { pattern = "%f[%w]()TEMPFIX()%f[%W]", group = "MiniHipatternsTodo" },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})
