--[[

Lets suppose that system will convert every entity every frame
That would automatically mean that this transformation would apply to all entities (even with huge data) every frame
^ this will result in catastrophical computational loss due to the fact that most entities dont really need to be recomputated every frame
due to unchanging fields

we only need to recompute changed properties
if we stick with the

we only need runtime conversion for the replication and datastore
anything outside this scope doesnt require any runtime conversions
or it can be done not in runtime but in specific intervals

^ maybe we should use replecs method to detect updates?
should we use replecs for replication and interval saves for datastore?

replecs doesnt allow us to transform one data into another
but i can replicate only some components instead of all

---- Replication

the main idea is to swap from the original object based replication towards snapshot based
instead of sending some changes of one entity trasnformed into an object
we will focus on capturing all of the changes of components, entities and operations that need to be replicated

the main problem would be to create a proper mapping between server and client

we would need to make it so that entities could be mapped ontop of already existing entities
make it so that entities could be created on the client according to the server
make replicated components to client components mapping
make names for components

it needs to be automatic + have minimal amount of boilerplate

on the opposite side we have schema based approach (entity to object, send said object)

entity
- HP (int)
- Name (name)
- Damage (int)
- Sheild (int)
->
{
    Hp = 10,
    Name = "test",
    Damage = 10,...
}


entity -> schema


---- Replication (More)

The main idea: 
Create a map of components for different envirionments

{
    HealthComponent (server) = "HealthComponent" (tag)
}

{
    HealthComponent (client) = "HealthComponent" (tag)
}

-- ^ but by doing so we will have to specify their types
which would need to match

which means that theres no point in doing 2 separate components
we get data encapsulation but in return we have to duplicate every component (even if it matches with the server)

the only way is to create another module in shared which would only have data in it

]]
