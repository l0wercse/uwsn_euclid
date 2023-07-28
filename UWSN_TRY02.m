clc;

Range = 250;
Nodes = 150;

min.x = 0;
min.y = 0;
min.z = 0;

max.x = 1000;
max.y = 1000;
max.z = -1000;

sink(1,1)=300;
sink(1,2)=500;
sink(1,3)=-200;

sink(2,1)=750;
sink(2,2)=350;
sink(2,3)=-200;

sink(3,1)=100;
sink(3,2)=1000;
sink(3,3)=100;

sink(4,1)=250;
sink(4,2)=1000;
sink(4,3)=250;

sink(5,1)=900;
sink(5,2)=400;
sink(5,3)=250;

sink(6,1)=500;
sink(6,2)=500;
sink(6,3)=250;

nodePositions = createNodes(min, max,Nodes);
plot3(nodePositions(:, 1), nodePositions(:, 2),nodePositions(:, 3), '*');
hold on

plot3(sink(1, 1), sink(1, 2), sink(1, 3), 'S', 'MarkerFaceColor', 'g');
plot3(sink(2, 1), sink(2, 2), sink(2, 3), 'S', 'MarkerFaceColor', 'g');
plot3(sink(3, 1), sink(3, 2), sink(3, 3), 'S', 'MarkerFaceColor', 'b');
plot3(sink(4, 1), sink(4, 2), sink(4, 3), 'S', 'MarkerFaceColor', 'b');
plot3(sink(5, 1), sink(5, 2), sink(5, 3), 'S', 'MarkerFaceColor', 'b');
plot3(sink(6, 1), sink(6, 2), sink(6, 3), 'S', 'MarkerFaceColor', 'b');

lostPackets = 0;
avgTime = 0;

t1 = clock;

for i=1:Nodes
    visitedNodes = [];
    source = i;
    forwarder = source;
    fprintf('Node %d \n', i);
    [neighbours, success, nearestNode] = find_route (forwarder, sink, Range,Nodes, nodePositions, visitedNodes);
    visitedNodes(end+1) = source;
    while (success == 0 || isempty(neighbours) == 0)
        forwarder = nearestNode;
        if (forwarder == Inf)
            success = 0;
            disp('Packet Lost')
            lostPackets = lostPackets + 1;
            break;
        end
        visitedNodes(end+1) = forwarder;
        [neighbours, success, nearestNode] = find_route (forwarder, sink, Range,Nodes, nodePositions, visitedNodes);
    end
    disp('Route in which the packet travelled:')
    disp(visitedNodes)
    t2 = clock;
    e = etime(t2,t1);
    avgTime = (avgTime + e)/ i;
end
fprintf("Average end to end delay = %f ms \n", avgTime*1000)
t3 = clock;
totalTime = etime(t3,t1);
packetsDelivered = Nodes - lostPackets;
averagePacketsize = 80*8;
throughput = (packetsDelivered * averagePacketsize)/totalTime;
fprintf("Throughput = %f kbps \n", throughput/1000)
pdr = (Nodes - lostPackets)/Nodes;
fprintf('Packet Delivery Ratio = %f \n', pdr);