module Journals


using UUIDs
using Random: randstring
using OrderedCollections: OrderedDict
using JSON3
using Cobweb: h

import Base: show

export 
    Journal,
    JournalEntry, 
    add!,
    remove!,
    render

mutable struct JournalEntry{T<:Any}
    uuid::UUIDs.UUID
    config::Dict
    data::T
    name::String
end

function JournalEntry(data::Any, name::String)
    uuid = UUIDs.uuid1()
    config = Dict()
    JournalEntry(uuid, config, data, name)
end

JournalEntry(data::Any) = JournalEntry(data, "")


mutable struct Journal
    name::String
    uuid::UUIDs.UUID
    config::Dict
    data::Vector{JournalEntry}
end

Journal() = Journal(randstring())

function Journal(name::String)
    uuid = UUIDs.uuid1()
    config = Dict()
    data = JournalEntry[]
    Journal(name, uuid, config, data)
end

include("actions.jl")
include("render.jl")


end # module Journals
