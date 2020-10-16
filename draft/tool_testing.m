%     this is a demo
%     bla bla bla

function y = tool_testing(x)
    global t
    y = x + 1;
    y = y + little_tool(x);
    t = y;
end

function result = little_tool(a)
    result = a*2;
end