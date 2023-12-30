
function _render_dict(d::Union{OrderedDict,Dict}; show_to_level=1, max_string_length=20, sort_objects=false)
    jsn_str = JSON3.write(d)
    rndid = randstring(6)
    h.div(
        class="container",
        h.div(class="json-container", id=rndid),
        h.script(
            """
            var data = $(jsn_str);
            renderjson.set_show_to_level($(show_to_level));
            renderjson.set_max_string_length($(max_string_length));
            renderjson.set_sort_objects($(sort_objects));
            document.getElementById('$(rndid)').appendChild(renderjson(data));
            """
        )
    )
end


"""
    render(e::JournalEntry)

If JournalEntry.data is a Vector{Number}, then render it as a JSON object.
"""
function render(e::JournalEntry{Vector{T}}) where {T <: Number}
    show_to_level = (length(e.data) < 11) ? 1 : 0
    e_dct = OrderedDict(x => y for (x,y) in enumerate(e.data)) # convert vector to dict
    _render_dict(e_dct; show_to_level=show_to_level)
end

function render(e::JournalEntry{Dict{T, U}}) where {T <: Any, U <: Any}
    _render_dict(e.data)
end

function render(e::JournalEntry)
    r = showable("text/html", e.data) ? repr("text/html", e.data) : repr("text/plain", e.data)
    h.div(r, class="container")
end




"""
    render(j::Journal)
"""
function render(j::Journal)
    objs = []
    for o in j.data
        r = render(o)
        push!(objs, r)
    end

    h.html(
        h.head(
            h.meta(charset="utf-8"),
            h.meta(name="viewport", content="width=device-width, initial-scale=1"),

            # jQuery
            h.script(src="https://code.jquery.com/jquery-3.7.1.min.js", 
                        integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=", 
                        crossorigin="anonymous"),

            # Bootstrap        
            h.link(rel="stylesheet", 
                    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css", 
                    integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN", 
                    crossorigin="anonymous"),
            
            h.script(src="https://cdnjs.cloudflare.com/ajax/libs/prism/9000.0.1/prism.min.js"),
            h.link(rel="stylesheet", href="https://cdnjs.cloudflare.com/ajax/libs/prism/9000.0.1/themes/prism.min.css"), 
            h.script(type="text/javascript", src="https://cdn.jsdelivr.net/npm/renderjson@1.4.0/renderjson.min.js"),

            h.script(rel="stylesheet", 
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"),
            h.script(rel="stylesheet", 
                        href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap"),

        ),
        h.body(
            h.h1("Here is a title!"),
            objs...,
            h.script(src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js", 
                        crossorigin="anonymous", 
                        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL")
        )
    )
end



