function linear_greedy(weighted_vec_list::Matrix{Float64})
    d = size(weighted_vec_list,2)-1
    order_vec = sortperm(weighted_vec_list[:,d+1],rev = true)
    sorted_vec = weighted_vec_list[order_vec,:]
    num_vec = size(sorted_vec,1)
    opt_vecs =zeros(0,d+1)
    opt_val = 0.0
    current_rank =0 
    # We check if adding a new vector will make the rank of the current set increase,
    # then we add  it, and renew the current rank.
    for i in 1:num_vec
        if i % 100 == 0
            println("Now checking vector ", i, " / ", num_vec,
                    ", current_rank = ", current_rank,
                    ", selected = ", size(opt_vecs, 1))
        end
        candidate_vec= sorted_vec[i:i,:]
        selected_vec = vcat(opt_vecs,candidate_vec)
        new_rank=rank(selected_vec[:,1:d])
        if new_rank > current_rank
            opt_val += sorted_vec[i,end]
            opt_vecs =selected_vec
            current_rank =new_rank
        end
    end
    return opt_vecs, opt_val
end