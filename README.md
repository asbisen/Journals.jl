# Journals.jl

A simple julia library to capture output from interactive Julia session to an HTML document. 

```julia
# instantiate a journal
using Journals
j = Journal()

out1 = rand(1:100, 100) # perform computation
add!(j, out1) # capture output

using CSV, DataFrames
out2 = CSV.read("mydata.csv", DataFrame)
add!(j, out2) # capture more output

using Markdown
txt = md"""Some *markdown* text"""
add!(j, txt) # capture more output

render(j) # Render HTML 
```

