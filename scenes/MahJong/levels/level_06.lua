local map = {}

map = { etages = 3, lignes = 6, colonnes = 6,  image = "tutorial_3.png", load = false,-- pics, sound, soundClear






  {-- etage 1
    { 1,    1,     1,     1,    1,    1  },
    { 1,    1,     1,     1,    1,    1  },
    { 1,    1,     1,     1,    1,    1  },
    { 1,    1,     1,     1,    1,    1  },
    { 1,    1,     1,     1,    1,    1  },
    { 1,    1,     1,     1,    1,    1  }

  },

  {-- etage 2
    { "",    "",     "",     "",    "",   "" },
    { "",     1,      1,      1,     1,   "" },
    { "",     1,      1,      1,     1,   "" },
    { "",     1,      1,      1,     1,   "" },
    { "",     1,      1,      1,     1,   "" },
    { "",    "",     "",    "" ,    "",   "" }

  },

  {-- etage 3
    { "",    "",      "",     "",    "",   "" },
    { "",    "",      "",     "",    "",   "" },
    { "",    "",       1,      1,    "",   "" },
    { "",    "",       1,      1,    "",   "" },
    { "",    "",      "",     "",    "",   "" },
    { "",    "",      "",     "",    "",   "" }

  }

}

return map
