classdef cluster
    properties
        m   % row position
        n   % col position
        px  % pixel vector
        S   % max search distance
    end
    
    properties (Access = private)
        Sm % row search distance
        Sn % col search distance
    end
    
    methods
        % cluster constructor
        function me = cluster(m,n,px,M,N,s)
            me.m = m;
            me.n = n;
            me.px = px;

            % max search (from position) is half the region height/width plus the minimum
            % dimension of the smallest seed region
            me.Sm = floor(M / 2) + s;
            me.Sn = floor(N / 2) + s;
        end
        
        % get rows to search based on current position
        function result = mm(me,M)
            m1 = max(1,me.m - me.Sm);
            m2 = min(M,me.m + me.Sm);
            result = m1:m2;
        end
        
        % get cols to search based on current position
        function result = nn(me,N)
            n1 = max(1,me.n - me.Sn);
            n2 = min(N,me.n + me.Sn);
            result = n1:n2;
        end
        
        function value = get.S(me)
            value = max(me.Sm, me.Sn);
        end
    end
end