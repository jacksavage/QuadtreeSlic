classdef priority_queue < handle   
    properties
        nodes = node;
        tail; % keep track of next open array index
    end
    
    methods (Static)
        function result = parent_i(i); result = idivide(i,2); end
        function result = left_child_i(i); result = i * 2; end
        function result = right_child_i(i); result = priority_queue.left_child_i(i) + 1; end
    end
            
    methods
        % simple utility methods        
        function result = has_parent(me,i); result = (i ~= 1); end
        function result = has_left_child(me,i); result = (priority_queue.left_child_i(i) < me.tail); end
        function result = has_right_child(me,i); result = (priority_queue.right_child_i(i) < me.tail); end
        
        function result = right_child_priority(me,i); result = me.nodes(priority_queue.right_child_i(i)).priority; end
        function result = left_child_priority(me,i); result = me.nodes(priority_queue.left_child_i(i)).priority; end
        function result = parent_priority(me,i); result = me.nodes(priority_queue.parent_i(i)).priority; end
        
        % swap two nodes given their index
        function swap(me,ia,ib)
            buffer = me.nodes(ia);
            me.nodes(ia) = me.nodes(ib);
            me.nodes(ib) = buffer;
        end
        
        % constructor
        function me = priority_queue(size)
            me.nodes(1:size,1) = node(-1);
            me.tail = uint32(1);
        end     
        
        % add an element to the queue
        function enqueue(me,n)
            % insert node into next open spot
            i = me.tail; 
            me.nodes(i) = n;
            me.tail = me.tail + 1;
            
            % move the new root up as needed
            heapify_up(me);
        end
        
        function heapify_up(me)
            i = me.tail - 1;
            while has_parent(me,i) && parent_priority(me,i) < me.nodes(i).priority
                i_parent = priority_queue.parent_i(i);
                swap(me,i_parent,i);
                i = i_parent;
            end
        end
        
        % remove the root node from the queue
        function n = dequeue(me)
            % if queue is empty, return an 'empty' node
            if me.tail == 1
                n = node(-1); 
                return; 
            end
            
            % otherwise grab data from root node
            % then move the last inserted node to the root
            n = me.nodes(1);
            me.nodes(1) = me.nodes(me.tail - 1);
            me.tail = me.tail - 1;
            
            % move the new root node down as needed
            heapify_down(me);
        end
   
        function heapify_down(me)
           i = 1;
           while has_left_child(me,i)
               % get index of *max* child
               i_max_child = priority_queue.left_child_i(i);
               if has_right_child(me,i)
                   if right_child_priority(me,i) > left_child_priority(me,i)
                       i_max_child = priority_queue.right_child_i(i);
                   end
               end
               
               % if current node has higher priority than highest priority child, we're done
               if me.nodes(i).priority > me.nodes(i_max_child).priority; return; end
               
               % otherwise swap current node with max child
               swap(me,i,i_max_child);
               i = i_max_child;
           end
        end
    end
end
