function permute2(a,b)
    result = [
        (a,b),
        (b,a),
     ]
     return result
end

function permute3(a,b,c)
    result = [
        (a,b,c),
        (a,c,b),
        (b,a,c),
        (b,c,a),
        (c,a,b),
        (c,b,a),
     ]
     return result
end

function permute4(a,b,c,d)
    result = [
        (a,b,c,d),
        (a,b,d,c),
        (a,c,b,d),
        (a,c,d,b),
        (a,d,b,c),
        (a,d,c,b),
        (b,a,c,d),
        (b,a,d,c),
        (b,c,a,d),
        (b,c,d,a),
        (b,d,a,c),
        (b,d,c,a),
        (c,a,b,d),
        (c,a,d,b),
        (c,b,a,d),
        (c,b,d,a),
        (c,d,a,b),
        (c,d,b,a),
        (d,a,b,c),
        (d,a,c,b),
        (d,b,a,c),
        (d,b,c,a),
        (d,c,a,b),
        (d,c,b,a),
     ]
     return result
end
