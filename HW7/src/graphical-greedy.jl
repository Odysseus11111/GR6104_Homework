

#We first implement the main function , input is weighted_edge_list, 
#an n-by-3 array. 

function graphical_greedy(weighted_edge_list)
    num_edges = size(weighted_edge_list,1)
    nodes= unique(vec(weighted_edge_list[:,1:2]))
    num_nodes = maximum(nodes)

    # Initialization 
    mst = []
    opt_val = 0
    sort_edges = sortperm(weighted_edge_list[:,3],rev = true)
    selected_edges = weighted_edge_list[sort_edges,:]
    a = IntDisjointSet(num_nodes)

    for i in 1:num_edges
        x = selected_edges[i,1]
        y = selected_edges[i,2]
        w = selected_edges[i,3]
        if !in_same_set(a,x,y)
            union!(a,x,y)
            opt_val += w
            push!(mst,[x,y,w]) 
        end
        
    end
    return opt_val,mst
end

