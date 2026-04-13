#We first implement the main function , input is weighted_edge_list, 
#an n-by-3 array. 
using DataStructures
using LinearAlgebra

function graphical_greedy(weighted_edge_list)
    if isempty(weighted_edge_list)
        return (Int[], 0.0) 
    end
    num_edges = size(weighted_edge_list,1)
    nodes= unique(vec(weighted_edge_list[:,1:2]))
    num_nodes = Int(maximum(nodes))

    # Initialization 
    mst = Vector{Tuple{Int,Int,Float64}}()
    opt_val = 0.0
    sort_edges = sortperm(weighted_edge_list[:,3],rev = true)
    selected_edges = weighted_edge_list[sort_edges,:]
    a = IntDisjointSet(num_nodes)

    for i in 1:num_edges
        x = Int(selected_edges[i,1])
        y = Int(selected_edges[i,2])
        w = selected_edges[i,3]
        if !in_same_set(a,x,y)
            union!(a,x,y)
            opt_val += w
            push!(mst, (x, y, w))
            if length(mst) == num_nodes - 1
                break
            end
        end
    end
    mst_matrix = hcat([e[1] for e in mst],[e[2] for e in mst],[e[3] for e in mst])
    return mst_matrix,opt_val
end

