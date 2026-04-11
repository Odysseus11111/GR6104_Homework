

#We first implement the main function , input is weighted_edge_list, 
#an n-by-3 array. 
using DataStructures
using LinearAlgebra

function graphical_greedy(weighted_edge_list)
    num_edges = size(weighted_edge_list,1)
    nodes= unique(vec(weighted_edge_list[:,1:2]))
    num_nodes = Int(maximum(nodes))

    # Initialization 
    mst = []
    opt_val = 0
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
            push!(mst,[x,y,w]) 
        end
        
    end
    return mst,opt_val
end

function linear_greedy(weighted_vec_list::Matrix{Float64})

    d = size(weighted_vec_list,2)-1
    order_vec = sortperm(weighted_vec_list[:,d+1],rev = true)
    sorted_vec = weighted_vec_list[order_vec,:]
    num_vec = size(sorted_vec,1)
    opt_vecs =zeros(0,d+1)
    opt_val = 0
    current_rank =0 
    # We check if adding a new vector will make the rank of the current set increase,
    # then we add  it, and renew the current rank.
    for i in 1:num_vec
        candicate_vec= sorted_vec[i:i,:]
        selected_vec = vcat(opt_vecs,candicate_vec)
        new_rank=rank(selected_vec[:,1:d])
        if new_rank > current_rank
            opt_val += sorted_vec[i,end]
            opt_vecs =selected_vec
            current_rank =new_rank
        end
    end
    return opt_vecs, opt_val
end