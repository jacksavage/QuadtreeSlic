classdef img_range
    properties
        left;
        right;
        top;
        bottom;
        
        height;
        width;
        area;
        middle;
        center;
    end
    
    methods
        function me = img_range(left,right,top,bottom)
            if nargin > 0
                me.left = left;
                me.right = right;
                me.top = top;
                me.bottom = bottom;
            end
        end
        
        function value = get.height(me)
            value = me.bottom - me.top + 1;
        end
        
        function value = get.width(me)
            value = me.right - me.left + 1;
        end
        
        function value = get.area(me)
            value = me.width * me.height;
        end
        
        function value = get.middle(me)
            value = me.top + (me.bottom - me.top) / 2;
        end
        
        function value = get.center(me)
            value = me.left + (me.right - me.left) / 2;
        end
        
        function cropped = crop(me,I)
            cropped = I(me.top:me.bottom,me.left:me.right,:);
        end
    end
end
