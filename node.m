classdef node < handle
    properties
        priority;
        data;
    end
    
    methods
        function me = node(priority,data)
            if nargin > 0; me.priority = priority; end
            if nargin > 1; me.data = data; end
        end
    end
end
