classdef img_range
    properties
        left;
        right;
        top;
        bottom;
        area;
    end
    
    methods
        function me = img_range(left,right,top,bottom)
            me.left = left;
            me.right = right;
            me.top = top;
            me.bottom = bottom;
        end
        
        function value = get.area(me)
            width = me.right - me.left;
            height = me.bottom - me.top;
            value = width * height;
        end
    end
end
