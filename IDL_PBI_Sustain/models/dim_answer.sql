select 
    *,
    from raw_answer
    pivot(max(value) for translation in (any))
    


