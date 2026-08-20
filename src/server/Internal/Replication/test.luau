--[[

we can place replicated components under shared modules
that way operations will utilize shared components

server/client only components would be places in the corresponding modules
operations need to stay simple and have no idea about replecs 
they only can import shared components

replication needs to be added externally (replication pairs)
but creating replication operations will result in code duplicate 
so that we will register the same components twice
the only difference is the fact that we will use jecs.pairs

]]
