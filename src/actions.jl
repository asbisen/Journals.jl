

"""
    add!(journal::Journal, entry::JournalEntry)
    add!(journal::Journal, data::Any)

Add a JournalEntry to a Journal object. The JournalEntry is created from the data.
In the event that the second argument is not `JournalEntry`, then a new JournalEntry
is created from the data. A unique UUID is generated automatically for the JournalEntry.
"""
function add!(journal::Journal, entry::JournalEntry)
    push!(journal.data, entry)
    journal
end

function add!(journal::Journal, data::Any)
    entry = JournalEntry(deepcopy(data))
    add!(journal, entry)
end


"""
    remove!(journal::Journal, idx::Int)
    TODO: remove!(journal::Journal, uuid::String)

    Remove a JournalEntry from a Journal object at the given index.
"""
function remove!(journal::Journal, idx::Int)
    deleteat!(journal.data, idx)
    journal
end

function remove!(journal::Journal, uuid::String)
    objects = string.(getfield.(journal.data, :uuid))
    idx = findfirst(objects .== uuid)
    if !(idx === nothing)
        remove!(journal, idx)
    end
end

"""
    show(io::IO, ::MIME"text/plain", j::Journal)

Pretty print the Journal object to text/plain MIME type.
"""
function show(io::IO, ::MIME"text/plain", j::Journal)
    println(io, "Journal: $(j.name)")
    println(io, "UUID: $(j.uuid)")
    println(io, "Config: $(j.config)")
    for (idx,e) in enumerate(j.data)
        println("$idx - $(e.uuid): $(typeof(e.data))")
    end
end