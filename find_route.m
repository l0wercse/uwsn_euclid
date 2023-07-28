function[neighbours, success, nearestNode] = find_route(forwarder, sink,transRange, numNodes, nodePositions, visitedNodes)
    success = 0;
    neighbours = [];
    index = 1;
    nearestNode = 1/0;
    shortestDist = 1/0;
    fx = nodePositions(forwarder,1);
    fy = nodePositions(forwarder,2);
    fz = nodePositions(forwarder,3);
    
    for i=1: 6
        sink_x = sink(i,1);
        sink_y = sink(i,2);
        sink_z = sink(i,3);
        dst_sink = sqrt((fx- sink_x)^2 + (fy- sink_y)^2 + (fz- sink_z)^2);
        if (dst_sink < shortestDist)
            shortestDist = dst_sink;
        end
        if( shortestDist <= transRange)
            success = 1;
            disp('Packet reached at sink node successfully')
            return;
        end
    end
    for i=1: numNodes
        if (forwarder == i)
            continue;
        end
        x = nodePositions(i,1);
        y = nodePositions(i,2);
        z = nodePositions(i,3);
        distance = sqrt((fx-x)^2 + (fy-y)^2 + (fz-z)^2);
        if (distance <= transRange)
            neighbours(index)=i;
            index = index +1;
            neighbours(ismember(neighbours,visitedNodes)) = [];
            if (distance < nearestNode & neighbours(ismember(neighbours,i)))
                nearestNode = i;
            end
        end
    end
    return
end